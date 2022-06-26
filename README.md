# Clasik ASP Multiple Upload
Clasik asp üzerine kendi dişine göre özelleştirilebilir bir yazılım bulamayanlar için istediğiniz gibi özelleştirebilirsiniz.

Upload Form'unda 

<form method="POST" action="upload.asp?id=<%=comment("id")%>" enctype="multipart/form-data">
<input class="upselect btn btn-outline-secondary" type="file" name="files[]" multiple>
<input class="upsubmit btn btn-outline-secondary" name="submit" type="submit" value="Yükle">
</form>

Şeklinde multiple methodunu eklemeyi unutmayın. Ajax ile zenginleştirmek için bana ulaşabilirsiniz. bi boşlukta proje halinide paylaşacağım ama biraz sürebilir :)
