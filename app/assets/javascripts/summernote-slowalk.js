var initializeSummernote = function() {
  $('[data-provider="summernote"]').each(function() {
    $(this).summernote({
      toolbar: [
        ['uploadcare', ['uploadcare']], // here, for example
        ["style", ["style"]],
        ['style', ['bold', 'italic', 'underline', 'clear']],
        ['font', ['strikethrough', 'superscript', 'subscript']],
        ['fontname', ['fontname']],
        ['fontsize', ['fontsize']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['height', ['height']],
        ['table', ['table']],
        ['insert', ['media', 'link', 'hr', 'picture', 'video']],
        ['view', ['fullscreen', 'codeview', 'undo']],
        ['help', ['help']]
      ],
      height: 500,
      lang: 'ko-KR',
      fontNames: ['Noto Sans Korean', 'Nanum Myeongjo', 'Nanum Gothic', 'Malgun Gothic', 'gulim', 'Batang','Arial', 'Arial Black', 'Comic Sans MS', 'Courier New', ],
      fontSizes: ['8', '9', '10', '11', '12', '14', '16', '18', '20', '24', '36', '48', '64', '82'],
      fontNamesIgnoreCheck: ['Noto Sans Korean', 'Nanum Myeongjo', 'Nanum Gothic', 'Malgun Gothic', 'gulim', 'Batang'],
      insertTableMaxSize: {
        col: 20,
        row: 30
      },
      callbacks: {
        onImageUpload: function(files) {
          sendFile(files[0], $(this));
        },
        onMediaDelete: function(target, editor, editable) {
          console.log(target);
          var asset_id = target[0].id.split('-').slice(-1)[0];
          console.log(asset_id);
          if (!!asset_id) {
            deleteFile(asset_id);
          }
          target.remove();
        }
      }
    });

    var sendFile;
    sendFile = function(file, self) {
      var data;
      data = new FormData;

      var name = file.name;
      var is_image = file.type.split("/")[0] == "image";

      data.append('asset[file]', file);

      $.ajax({
        data: data,
        type: 'POST',
        url: '/admin/assets',
        cache: false,
        contentType: false,
        processData: false,
        success: function(data) {
          if(is_image){
            self.summernote("insertImage", data.image_url, function($image) {
              $image.attr('id', 'sn-asset-'+data.asset_id);
            });
          }else{
            file_html = '<div class="file"><a download="'+name+'" href="'+data.file_url+'">'+name+'</a></div>';
            self.summernote('pasteHTML', file_html);
          }
        }
      });
    };

    var deleteFile;
    deleteFile = function(file) {
      $.ajax({
        type: 'DELETE',
        url: "/admin/assets/"+file,
        cache: false,
        contentType: false,
        processData: false
      });
    }

  });
}