ytdl() {
  yt-dlp --js-runtimes bun --remote-components ejs:github -f bestaudio --extract-audio --audio-format mp3 \
    --audio-quality 0 --embed-metadata --embed-thumbnail \
    --parse-metadata "title:(?P<title>.+) - (?P<artist>.+) \|.*" --add-metadata \
    --metadata-from-title "%(artist)s - %(title)s" \
    --parse-metadata "duration_string:%(meta_comment)s" \
    --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -q:v 3" \
    --ppa "FFmpegExtractAudio:-write_xing 1" \
    -o "%(artist)s - %(title)s.%(ext)s" "$@"
}
