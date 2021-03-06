﻿<%@ Page Language="C#" Debug="true"%>
    <script language="c#" runat="server">         	//出貨單列印_榮泉
        public class ParaIn{
            public string bno = "D1070330001", eno = "D1070330001", bdate = "", edate = "";
        }
        public class Vcc{
            public string noa;
            public Item[] item;
        }
        public class Item{
            public string accy, noa, noq;
            public string datea,tel,addr,vccno,cust,product,uno,size,unit;
            public float mount,weight,price,total,total2,total3,total4;
            //public string memo;
            public float t_total;
       }
        public void inputTitle(iTextSharp.text.pdf.PdfContentByte cb ,Item[] item,int page){
            iTextSharp.text.pdf.BaseFont bfChinese,bold;
            if(Environment.OSVersion.Version.Major>6){
            	bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttc,0", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
           		bold = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttc,1", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            }else{
            	bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            	bold = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjhbd.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            }
            cb.BeginText();
			//////表頭//////
            cb.SetFontAndSize(bfChinese, 60);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, "■", 477, 380, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, "■", 495, 380, 0);
            cb.SetFontAndSize(bfChinese, 30);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "榮泉", 400, 380, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "│ 　 │", 356, 380, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "───", 368, 396, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "───", 368, 364, 0);
            cb.SetFontAndSize(bfChinese, 8);
            if (item.Length <= 12)
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, "1/1", 550, 380, 0);
            else if (item.Length > 12 && item.Length % 12 != 0)
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, +page + "/" + ((item.Length / 12) + 1), 550, 380, 0);
            else if (item.Length > 12 && item.Length % 12 == 0)
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, +page + "/" + (item.Length / 12), 500, 550, 0);

            cb.SetFontAndSize(bfChinese, 11);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)item[0]).cust, 75, 355, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, ((Item)item[0]).tel, 385, 355, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)item[0]).vccno, 520, 355, 0);

            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)item[0]).addr, 75, 345, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)item[0]).datea, 520, 345, 0);
            /////表尾////
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "合計", 478, 148, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "稅金", 478, 138, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "總額", 478, 128, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)item[0]).total2.ToString(), 590, 148, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)item[0]).total3.ToString(), 590, 138, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)item[0]).total4.ToString(), 590, 128, 0);
            cb.EndText();
        }
        
        System.IO.MemoryStream stream = new System.IO.MemoryStream();
        string connectionString = "";
        public void Page_Load(){
        	string db = "st";
        	if(Request.QueryString["db"] !=null && Request.QueryString["db"].Length>0)
        	db= Request.QueryString["db"];
        	connectionString = "Data Source=60.249.177.127,1799;Persist Security Info=True;User ID=sa;Password=artsql963;Database="+db;  //資料庫連結
			var item = new ParaIn();
            if (Request.QueryString["bno"] != null && Request.QueryString["bno"].Length > 0){
                item.bno = Request.QueryString["bno"];
            }
            if (Request.QueryString["eno"] != null && Request.QueryString["eno"].Length > 0){
                item.eno = Request.QueryString["eno"];
            }
            if (Request.QueryString["bdate"] != null && Request.QueryString["bdate"].Length > 0){
                item.bdate = Request.QueryString["bdate"];
            }
            if (Request.QueryString["edate"] != null && Request.QueryString["edate"].Length > 0){
                item.edate = Request.QueryString["edate"];
            }
            System.Data.DataSet ds = new System.Data.DataSet();
            
            using (System.Data.SqlClient.SqlConnection connSource = new System.Data.SqlClient.SqlConnection(connectionString)){
                System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter();
                connSource.Open();
                string queryString = @"
										set @t_eno = case when len(@t_eno)=0 then char(255) else @t_eno end
										set @t_edate = case when len(@t_edate)=0 then char(255) else @t_edate end
										declare @tmpa table(noa nvarchar(20),n int)
										declare @tmpb table(
											noa nvarchar(20),
											noq nvarchar(10),
											datea nvarchar(30),
											vccno nvarchar(50),
											tel nvarchar(50),
											addr nvarchar(50),
											cust nvarchar(max),
											product nvarchar(max),
											uno nvarchar(max),
											size nvarchar(max),
											unit nvarchar(20),
											mount float,
											weight float,
											price float,
											total float,
											total2 float,
											total3 float,
											total4 float
										)
										insert into @tmpb(noa,noq,datea,vccno,tel,addr,cust,product,uno,size,unit,mount,weight,price,total,total3,total4)
										select top 50 b.noa,b.noq,a.datea,a.noa,a.tel,a.addr,a.comp,b.product,b.uno,b.size,b.unit,b.mount,b.weight,b.price,b.total,a.tax,a.total
										from view_vcc a
										left join view_vccs b on a.noa = b.noa
										left join cust c on a.custno = c.noa
										where (a.noa between @t_bno and @t_eno) and (a.datea between @t_bdate and @t_edate) order by a.noa,b.noq

										insert into @tmpa(noa,n)select noa,count(1) from @tmpb group by noa order by noa

										update @tmpb set total2 = b.total from @tmpb a
										outer apply (select SUM(total) as total,noa from @tmpb where noa=a.noa group by noa)b
										update @tmpb set datea = convert(nvarchar,dbo.ChineseEraName2AD(datea),120) select * from @tmpa
										select * from @tmpb";
                System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(queryString, connSource);
                cmd.Parameters.AddWithValue("@t_bno", item.bno);
                cmd.Parameters.AddWithValue("@t_eno", item.eno);
                cmd.Parameters.AddWithValue("@t_bdate", item.bdate);
                cmd.Parameters.AddWithValue("@t_edate", item.edate);
                adapter.SelectCommand = cmd;
                adapter.Fill(ds);
                connSource.Close();
            }
            Vcc[] vcc = new Vcc[ds.Tables[0].Rows.Count];
            for (int i = 0; i < vcc.Length; i++){
                vcc[i] = new Vcc();
                vcc[i].noa = System.DBNull.Value.Equals(ds.Tables[0].Rows[i].ItemArray[0]) ? "" : (System.String)ds.Tables[0].Rows[i].ItemArray[0];
                vcc[i].item = new Item[System.DBNull.Value.Equals(ds.Tables[0].Rows[i].ItemArray[1]) ? 0 : (System.Int32)ds.Tables[0].Rows[i].ItemArray[1]];
                int n = 0;
                for(int j=0;j<ds.Tables[1].Rows.Count;j++){
                    if(vcc[i].noa == (System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[0]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[0])){
                        vcc[i].item[n] = new Item();
                        vcc[i].item[n].noa = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[0]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[0];
                        vcc[i].item[n].noq = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[1]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[1];
                        vcc[i].item[n].datea = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[2]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[2];
                        vcc[i].item[n].vccno = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[3]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[3];
                        vcc[i].item[n].tel = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[4]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[4];
                        vcc[i].item[n].addr = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[5]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[5];
                        vcc[i].item[n].cust = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[6]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[6];
                        vcc[i].item[n].product = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[7]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[7];
                        vcc[i].item[n].uno = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[8]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[8];
                        vcc[i].item[n].size = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[9]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[9];
                        vcc[i].item[n].unit = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[10]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[10];
                        vcc[i].item[n].mount = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[11]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[11];
                        vcc[i].item[n].weight = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[12]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[12];
                        vcc[i].item[n].price = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[13]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[13];
                        vcc[i].item[n].total = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[14]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[14];
                        vcc[i].item[n].total2 = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[15]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[15];
                        vcc[i].item[n].total3 = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[16]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[16];
                        vcc[i].item[n].total4 = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[17]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[17];
                        n++;
                    }  
                }
            }
            //-----PDF--------------------------------------------------------------------------------------------------
            var doc1 = new iTextSharp.text.Document(iTextSharp.text.PageSize.A5);
            doc1 = new iTextSharp.text.Document(new iTextSharp.text.Rectangle(doc1.PageSize.Height, doc1.PageSize.Width), 0, 0, 0, 0);
            iTextSharp.text.pdf.PdfWriter pdfWriter = iTextSharp.text.pdf.PdfWriter.GetInstance(doc1, stream);
            //font
            iTextSharp.text.pdf.BaseFont bfChinese,bold;
            if(Environment.OSVersion.Version.Major>6){
            	bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttc,0", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
           		bold = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttc,1", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            }else{
            	bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            	bold = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjhbd.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            }
            iTextSharp.text.pdf.BaseFont bfNumber = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\ariblk.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            doc1.Open();
            iTextSharp.text.pdf.PdfContentByte cb = pdfWriter.DirectContent;
            if (vcc.Length == 0){
                cb.SetColorFill(iTextSharp.text.BaseColor.RED);
                cb.BeginText();
                cb.SetFontAndSize(bfChinese, 30);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "無資料", 20, 20, 0);
                cb.EndText();
            }else{
                for (int j = 0; j < vcc.Length; j++){
                    if(j>0)
                        doc1.NewPage();
                    for (int i = 0, y = 300, page = 1; i < vcc[j].item.Length; i++, y -= 10){    //"y"代表表身第一筆資料的高度
                        if (i == 0){
                            inputTitle(cb, vcc[j].item, page);
                        }
                        if (i >= 12 && i % 12 == 0){
                            doc1.NewPage();
                            page++;
                            y = 260;
                            inputTitle(cb, vcc[j].item, page);
                        }
                        //TEXT
                        cb.BeginText();
                        cb.SetFontAndSize(bfChinese, 10);
                        cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)vcc[j].item[i]).size, 108, y, 0);
                        cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)vcc[j].item[i]).mount.ToString(), 305, y, 0);
                        cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)vcc[j].item[i]).unit, 325, y, 0);
                        cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)vcc[j].item[i]).weight.ToString(), 400, y, 0);
                        cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)vcc[j].item[i]).price.ToString(), 490, y, 0);
                        cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)vcc[j].item[i]).total.ToString(), 590, y, 0);
						
						if (((Item)vcc[j].item[i]).uno.Length > 8){
							cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)vcc[j].item[i]).product, 20, y, 0);
							cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)vcc[j].item[i]).uno, 20, y -= 10, 0);
						}else{
							cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)vcc[j].item[i]).product + ((Item)vcc[j].item[i]).uno, 20, y, 0); // 要判斷uno超過8個字元後跳下一行
						}
                        cb.EndText();
                    }
                }
            }
            doc1.Close();
            Response.ContentType = "application/octec-stream;";
            Response.AddHeader("Content-transfer-encoding", "binary");
            Response.AddHeader("Content-Disposition", "attachment;filename=出貨單列印.pdf");
            Response.BinaryWrite(stream.ToArray());
            Response.End();
        }
    </script>