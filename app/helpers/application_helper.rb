module ApplicationHelper
  def default_meta_tags
    {
      site: 'まにまに散歩',
      title: '神様と歩く、いつもの道。',
      reverse: true,
      separator: '|',
      description: '目的地のない散歩は、もう終わり。あなたの何気ない歩みが、姿を忘れてしまった「土地神様」の力になります。',
      keywords: '散歩,土地神様,育成,ウォーキング',
      canonical: request.original_url,
      icon: [
        { href: image_url('icon.png') }, # 通常のファビコン
        { href: image_url('icon.png'), rel: 'apple-touch-icon', sizes: '180x180' } # iPhone用
      ],
      og: {
        site_name: 'まにまに散歩',
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('OGP.png'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image', # 画像を大きく見せるタイプ
      }
    }
  end
end
