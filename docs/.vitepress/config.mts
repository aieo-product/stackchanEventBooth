import { defineConfig } from 'vitepress'

export default defineConfig({
  lang: 'ja',
  title: 'スタックチャン撮影ブース',
  description: 'AI Dev Day 2026 スタックチャン お着替え＆撮影ブース 企画提案',
  lastUpdated: true,
  cleanUrls: true,
  head: [
    ['meta', { name: 'theme-color', content: '#1D76DB' }],
    ['meta', { property: 'og:title', content: 'スタックチャン お着替え＆撮影ブース｜AI Dev Day 2026' }],
    ['meta', { property: 'og:description', content: '着せ替えアクセサリー＋お誕生日ジオラマ撮影ブース。必要スペースとブース運営（13:00–17:00）の企画提案。' }],
    ['meta', { property: 'og:type', content: 'website' }]
  ],
  themeConfig: {
    nav: [
      { text: 'ブース概要', link: '/' },
      { text: 'アクセサリー', link: '/accessories' },
      { text: '撮影ブース', link: '/photobooth' },
      { text: '必要スペース', link: '/space' },
      { text: '当日運営', link: '/schedule' }
    ],
    sidebar: [
      {
        text: '企画提案',
        items: [
          { text: 'ブース概要', link: '/' },
          { text: '用意するアクセサリー', link: '/accessories' },
          { text: '簡易撮影ブース', link: '/photobooth' },
          { text: '必要スペース', link: '/space' },
          { text: '当日運営（13:00–17:00）', link: '/schedule' }
        ]
      }
    ],
    outline: { label: '目次', level: [2, 3] },
    docFooter: { prev: '前へ', next: '次へ' },
    darkModeSwitchLabel: '外観',
    returnToTopLabel: 'トップへ',
    lastUpdatedText: '最終更新',
    socialLinks: [
      { icon: 'github', link: 'https://github.com/aieo-product/stackchanEventBooth' }
    ]
  }
})
