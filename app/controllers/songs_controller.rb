class SongsController < ApplicationController
  before_filter :find_artist
  before_filter :find_song

  def index
    @songs = @artist && @artist.songs || Song.all
  end

  def show
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
  end

  def update

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def find_artist
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if !@artist
        flash[:alert] = "Artist not found"
        redirect_to artists_path
      end
    end
  end

  def find_song
    if params[:id]
      if @artist
        @song = @artist.songs.find_by(id: params[:id])
        if !@song
          flash[:alert] = "Song not found"
          redirect_to(artist_songs_path(@artist))
        end
      else
        @song = Song.find(params[:id])
      end
    end
  end

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end
end