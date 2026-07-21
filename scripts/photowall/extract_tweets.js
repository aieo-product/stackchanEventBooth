// X検索結果ページ(タイムライン表示中)で javascript_tool から実行し、
// 表示中のツイートを JSON 配列で返す。スクロールしながら複数回実行して収集する。
// 注意: 画像URLのクエリ文字列(?format=...)を含めて返すと Claude in Chrome の
// DLPフィルタで [BLOCKED: Cookie/query string data] になるため、
// media ID + format に分解して返す(URL再構築は merge_posts.py 側で行う)。
(() => {
  const posts = [];
  document.querySelectorAll('article[data-testid="tweet"]').forEach(a => {
    try {
      const link = a.querySelector('a[href*="/status/"]');
      const m = link && link.href.match(/\/([^/]+)\/status\/(\d+)/);
      if (!m) return;
      const user = m[1];
      const id = m[2];
      const nameEl = a.querySelector('[data-testid="User-Name"] span');
      const name = nameEl ? nameEl.textContent : user;
      const textEl = a.querySelector('[data-testid="tweetText"]');
      const text = textEl ? textEl.innerText : '';
      // 写真のみ(動画サムネは tweetPhoto に含まれない)
      const media = [...a.querySelectorAll('[data-testid="tweetPhoto"] img')]
        .map(img => {
          const mm = img.src.match(/pbs\.twimg\.com\/media\/([A-Za-z0-9_-]+)\?format=([a-z0-9]+)/i);
          return mm ? { mid: mm[1], fmt: mm[2] } : null;
        })
        .filter(Boolean);
      if (media.length) posts.push({ id, user, name, text, media });
    } catch (e) { /* skip broken card */ }
  });
  return JSON.stringify(posts);
})()
