class Book < ApplicationRecord

  has_one_attached :image
  belongs_to :user
  has_many :favorites, dependent: :destroy

  #favoriteモデルを通じて、userモデルから、favorited_usersを参照できます
  has_many :favorited_users, through: :favorites, source: :user

  has_many :post_comments, dependent: :destroy

  has_many :view_counts, dependent: :destroy


  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }  #1日
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }  #昨日
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
   #= 6日前の今日の00:00:00から、現在の時刻の23:59:59まで
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }
   #今から2週間前の始まりから1週間前の終わりまでの期間


  scope :created_2day_ago, -> { where(created_at: 2.day.ago.all_day) }
  scope :created_3day_ago, -> { where(created_at: 3.day.ago.all_day) }
  scope :created_4day_ago, -> { where(created_at: 4.day.ago.all_day) }
  scope :created_5day_ago, -> { where(created_at: 5.day.ago.all_day) }
  scope :created_6day_ago, -> { where(created_at: 6.day.ago.all_day) }

end
