<%
	id			= request.querystring("id")
	nowtime			= DateAdd("h",9,Now())
	savefolder		= "/upload/"
	savefolderth		= "/upload/thumbnails/"
	maxwidth		= 1024
	maxheight		= 768
	thumbssize		= 400
	
	'günü ayı ve yılı alıyoruz kişiselliştirmek isteyenler için
		yil=Year(date)		

		if month(date) < 10 then	
		ay = "0" & month(date)
		else
		ay = month(date)		
		end if

		if Day(date) < 10 then	
		gun = "0" & Day(date)
		else
		gun = Day(date)
		end if

	'Persits ASPUpload
	Set Upload = Server.CreateObject("Persits.Upload" )
	Upload.SaveVirtual savefolder 'Geçici olarak kaydetme dosyası 'Virtual' godaddy için gerekli sadece.

	For Each File in Upload.Files 'Burada döngü başlatıyoruzki kaç adet resim varsa hepsi yüklensin.
		'Numara değişkenine rastgele bir sayı atıyoruz
		Randomize
		Numara = INT (RND*9999999999999)+1

		Set rs = Server.CreateObject("ADODB.Recordset") 'Veri tabanı bağlantısı "pictures" tablosuna kaydediyor
		sor = "Select * from pictures"
		rs.open sor, baglan,1,3

		newname = gun&"."&ay&"."&yil&"-"&Numara& "." & File.ImageType
		rs.addnew
			 rs("katid")		= id 'Resim bir kategoriye bağlamak için "request.querystring" nesnesi ile çekiyoruz.
			 rs("uploaddate")	= nowtime 'Detaylı tarih formatı için özelleştirilebilir.
			 rs("filename")		= newname ' dosya ismi "457896452126.jpg" şeklinde özelleştirebilirsiniz.
		rs.update
		rs.close

			'Orjinal resim sanal dizinden açılıp yeniden boyutlandırılıp hologram eklenerek kaydediliyor.
			Set Jpeg = Server.CreateObject("Persits.Jpeg")
			Jpeg.Open File.Path
			if Jpeg.OriginalHeight>Jpeg.OriginalWidth then

			Jpeg.Height = maxheight
			Jpeg.Width = (Jpeg.OriginalWidth * maxheight) / Jpeg.OriginalHeight
				Jpeg.Canvas.DrawPNG 0, 0, Server.MapPath("/img/hologram.png") ' Resim üzerine hologram basmak için kullanılabilir.
			Jpeg.Save Server.Mappath(savefolder) & "\" & newname
			else
			Jpeg.Width = maxwidth
			Jpeg.Height = (Jpeg.OriginalHeight * maxwidth) / Jpeg.OriginalWidth
				Jpeg.Canvas.DrawPNG 0, 0, Server.MapPath("/img/hologram.png")
			Jpeg.Save Server.Mappath(savefolder) & "\" & newname
			end if
			
				'thumbnails resmi oluşturmak için
				Set JpegFitSquare = Server.CreateObject("Persits.Jpeg")
				JpegFitSquare.Open File.Path
				if JpegFitSquare.OriginalHeight>JpegFitSquare.OriginalWidth then
				JpegFitSquare.Height = thumbssize
				JpegFitSquare.Width = (JpegFitSquare.OriginalWidth * thumbssize) / JpegFitSquare.OriginalHeight
				JpegFitSquare.Save Server.Mappath(savefolderth) & "\" & newname
				else
				JpegFitSquare.Width = thumbssize
				JpegFitSquare.Height = (JpegFitSquare.OriginalHeight * thumbssize) / JpegFitSquare.OriginalWidth

				JpegFitSquare.Save Server.Mappath(savefolderth) & "\" & newname
				end if
				response.write "<img style='margin:5px;width:85px;height:85px;-webkit-border-radius:10px;-moz-border-radius:10px;border-radius:10px;' src=' https://www.domain.com"+savefolderth+""+newname+"' />" 'Bu bölüm style.css ile özelleştirilebilir örnek olması için koydum.

		File.Delete 'Sanalda tutulan orjinal dosyaları silmek için
	Next
	response.Write "<div class='alert alert-success' role='alert'>Resim(ler) Başarıyla yüklendi...</div>"
%>
