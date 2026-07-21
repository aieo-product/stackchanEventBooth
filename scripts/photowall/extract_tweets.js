// X検索結果ページ(タイムライン表示中)で javascript_tool から実行し、
// 表示中のツイートを JSON 配列で返す。スクロールしながら複数回実行して収集する。
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
      // 写真のみ(動画サムネは tweetPhoto に含まれない)。name=large で原寸相当を取得
      const images = [...a.querySelectorAll('[data-testid="tweetPhoto"] img')]
        .map(img => img.src.replace(/name=[a-z0-9]+/i, 'name=large'))
        .filter(src => src.includes('pbs.twimg.com/media'));
      if (images.length) posts.push({ id, user, name, text, images });
    } catch (e) { /* skip broken card */ }
  });
  return JSON.stringify(posts);
})()
