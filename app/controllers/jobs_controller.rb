class JobsController < ApplicationController
  before_action :authenticate_user!, except: :show
  def index
    @jobs = Job.all.includes(:user).where(user_id: current_user.id) #user_idがcurrent_user.idのJobを取得
    @entries = Entry.all.includes(:user,:job) #Entryを取得
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    image = Magick::ImageList.new('./public/twitter_ogp.png')
      draw = Magick::Draw.new
      title = cut_text(@job.title)
      draw.annotate(image, 0, 0, 0, -120, title) do
        self.font = 'app/assets/NotoSansJP-Bold.otf' #日本語対応可能なフォントにする
        self.fill = '#fff' #フォントの塗りつぶし色
        self.gravity = Magick::CenterGravity #描画基準位置(中央)
        self.font_weight = Magick::BoldWeight #フォントの太さ
        self.stroke = 'transparent' #フォント縁取り色(透過)
        self.pointsize = 48 #フォントサイズ（48pt）
      end
    image_path = image.write(uniq_file_name).filename #書き出したファイルのファイル名前
    image_url = cut_path(image_path) #不要なパスをcutする
    @job.image_url = image_url #@jobのimage_urlにcutしたimage_urlを代入
    if @job.save
        flash[:notice] = "投稿が保存されました"
        redirect_to @job
    else
        flash[:alert] = "投稿に失敗しました"
    end
  end

  def show
    @job = Job.find(params[:id])
    @entries = Entry.where(job_id:@job) #この一行を追加
  end

  private

  def cut_path(url)
    url.sub(/\.\/public\//, "")
  end

  def uniq_file_name
    "./public/#{SecureRandom.hex}.png"
  end

  def cut_text(text)
      text.scan(/.{1,15}/).join("\n")
  end

  def job_params
	params.require(:job).permit(:title, :content).merge(user_id: current_user.id)
  end

end
