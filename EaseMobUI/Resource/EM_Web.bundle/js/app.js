$(function() {
    var uploader = new plupload.Uploader({
        runtimes: 'html5',
        browse_button: 'btn-upload',
        container: 'drag_area',
        url: "files", // todo edit
        filters: {
            max_file_size: '10mb',
            mime_types: [{
                title: "Image files",
                extensions: "jpg,gif,png"
            }, {
                title: "Zip files",
                extensions: "zip"
            }]
        },
        init: {
            FilesAdded: function(up, files) {
            	up.start();
                console.log('start');
            },
            UploadProgress: function(up, file) {
                console.log(file.percent);
            },
            FileUploaded: function(up, file) {

                var panel = [];
                panel.push('<div class="file">');
                panel.push('<div class="column filename" filename="'+file.name+'">'+file.name+'</div>');
                panel.push('<div class="column size"> 1.3 KB</div>');
                panel.push('<div class="column download" title="下载文件"></div>');
                panel.push('<div class="column trash" title="删除文件"></div>')
                panel.push('</div>');

                $('#files').append(panel.join(''));
            },
            Error: function(up, err) {
                alert('Error #' + err.code + ': ' + err.message);
            }
        }
    });
    uploader.init();
});