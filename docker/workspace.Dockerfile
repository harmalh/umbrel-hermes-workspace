FROM node:22-alpine AS builder

WORKDIR /app
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

COPY upstream-workspace/package.json upstream-workspace/pnpm-lock.yaml upstream-workspace/.npmrc ./

RUN npm install -g pnpm && pnpm install --no-frozen-lockfile

COPY upstream-workspace/ .

RUN pnpm build

FROM node:22-alpine AS runner

WORKDIR /app
ENV NODE_ENV=production

RUN addgroup -S hermes && adduser -S hermes -G hermes

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
COPY --from=builder /app/server-entry.js ./

EXPOSE 3000

USER hermes

CMD ["node", "server-entry.js"]
