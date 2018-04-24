<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title></title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
			if (location.href.indexOf('?') < 0) {
                location.href = location.href + "?;;;;"+((new Date()).getUTCFullYear()-1911);
            }
            $(document).ready(function() {
            	q_getId();
                q_gf('', 'z_vccp_FP'); //123
            });
			function q_gfPost() {
				$('#q_report').q_report({
                        fileName : 'z_vccp_FP',
                        options : [{
	                        type : '0', //[1]
	                        name : 'accy',
	                        value : r_accy
	                    },{
	                        type : '1', //[2][3]
	                        name : 'xnoa'
	                    },{
	                        type : '1', //[4][5]
	                        name : 'date'
	                    },{
	                        type : '2', //[6][7]
	                        name : 'cust',
	                        dbf : 'cust',
	                        index : 'noa,comp',
	                        src : 'cust_b.aspx'
	                    },{
	                        type : '1', //[8][9]
	                        name : 'xmon'
						},{
							type : '8',//[10]
							name : 'xshowprice',
							value : "1@".split(',')
	                    },{
	                        type : '0', //[11] //判斷顯示小數點
	                        name : 'xacomp',
	                        value : q_getPara('sys.comp')
	                    }]
                    });
				q_popAssign();
                	$('#txtXmon1').mask('999/99');
	                $('#txtXmon2').mask('999/99');
	                $('#txtDate1').mask('999/99/99');
	                $('#txtDate1').datepicker();
	                $('#txtDate2').mask('999/99/99');
	                $('#txtDate2').datepicker();
				$('#txtXdate1').mask(r_picd);
				$('#txtXdate1').datepicker();
				$('#txtXdate2').mask(r_picd);
				$('#txtXdate2').datepicker();
				
				switch(q_getPara('sys.project').toUpperCase()){
					case 'XY':
						//預設
						$('#q_report').find('span.radio').eq(1).click();
						$('#Xdetail').find('input[type=checkbox]').eq(0).prop('checked',true);
						break;
				}
				var t_para = new Array();
	            try{
	            	t_para = JSON.parse(q_getId()[3]);
	            }catch(e){
	            }    
	            if(t_para.length==0 || t_para.noa==undefined){
	            }else{
	            	$('#txtXnoa1').val(t_para.noa);
	            	$('#txtXnoa2').val(t_para.noa);
	            	$('#txtYnoa').val(t_para.noa);
	            }
	            
				$('#btnOk').before($('#btnOk').clone().attr('id', 'btnOk2').attr('value','查詢').show()).hide();
				$('#btnOk2').click(function() {
					var t_invoice = $.trim($('#txtYnoa').val());
					var bno = $.trim($('#txtXnoa1').val());
					var einvono = $.trim($('#txtXnoa2').val());
					var detail = $('#chkXdetail').children().eq(0).prop('checked')?"true":"false";
					var autoprint = $('#chkXautoprint').children().eq(0).prop('checked')?"true":"false";
					var bdate = $.trim($('#txtXdate1').val());
					var edate = $.trim($('#txtXdate2').val());
					switch($('#q_report').data('info').radioIndex) {
						case 0:
							window.open("./pdf_vccp_fp1.aspx?db="+q_db+"&bno="+$('#txtXnoa1').val()+"&eno="+$('#txtXnoa2').val());
							break;
						case 1:
							window.open("./pdf_vccp_fp2.aspx?db="+q_db+"&bno="+$('#txtXnoa1').val()+"&eno="+$('#txtXnoa2').val());
							break;
                  		default:
                  			$('#result').hide();
                  			$('#btnOk').click();
                  			break;
                  	}
					
				});
			}
			function q_getPrintPost(){
				var t_noa = $.trim($('#txtXnoa').val());
				if(t_noa.length > 0){
					$('#btnOk').click();
				}
			}

			function q_boxClose(s2) {
			}

			function q_gtPost(s2) {
			}
			
			PDFFileName = [];
			var OpenWindows=function(n){
			    if(n>=PDFFileName.length){
			    	//done
			        return;
			    }
			    else {
			    	console.log("../htm/htm/"+PDFFileName[n]);
			    	window.open("../htm/htm/"+PDFFileName[n]);
			    	n++;
			        setTimeout("OpenWindows("+n+")", 1500);
			    }
			};
			
			function invoice57(binvono,einvono,detail,autoprint){
				$.ajax({
					url: "pdf_vcca01.aspx?db="+q_db+"&binvono="+binvono+"&einvono="+einvono+"&isdetail="+detail+"&isautoprint="+autoprint,
                    type: 'POST',
                    data: JSON.stringify(""),
                    dataType: 'text',
                    timeout: 10000,
                    success: function(data){
                    	try{
                			PDFFileName = [];
                    		PDFFileName = JSON.parse(data);
                    		OpenWindows(0);
                    	}catch(e){
                    	}
                    },
                    complete: function(){
                    
                    },
                    error: function(jqXHR, exception) {
                        var errmsg = this.url+'資料讀取異常。\n';
                        if (jqXHR.status === 0) {
                            alert(errmsg+'Not connect.\n Verify Network.');
                        } else if (jqXHR.status == 404) {
                            alert(errmsg+'Requested page not found. [404]');
                        } else if (jqXHR.status == 500) {
                            alert(errmsg+'Internal Server Error [500].');
                        } else if (exception === 'parsererror') {
                            alert(errmsg+'Requested JSON parse failed.');
                        } else if (exception === 'timeout') {
                            alert(errmsg+'Time out error.');
                        } else if (exception === 'abort') {
                            alert(errmsg+'Ajax request aborted.');
                        } else {
                            alert(errmsg+'Uncaught Error.\n' + jqXHR.responseText);
                        }
                    }
                });	
			}
			function pdf_vcca01_rs(binvono,einvono,bdate,edate){
				$.ajax({
					url: "pdf_vcca01_rs.aspx?db="+q_db+"&binvono="+binvono+"&einvono="+einvono+"&bdate="+bdate+"&edate="+edate,
                    type: 'POST',
                    data: JSON.stringify(""),
                    dataType: 'text',
                    timeout: 10000,
                    success: function(data){
                    	try{
                    		tmp = JSON.parse(data);
                    		if(tmp.status==1){
                    			window.open("../htm/htm/"+tmp.filename);
                    		}else{
                    			alert(tmp.message);
                    		}
                    	}catch(e){
                    	}
                    },
                    complete: function(){
                    
                    },
                    error: function(jqXHR, exception) {
                        var errmsg = this.url+'資料讀取異常。\n';
                        if (jqXHR.status === 0) {
                            alert(errmsg+'Not connect.\n Verify Network.');
                        } else if (jqXHR.status == 404) {
                            alert(errmsg+'Requested page not found. [404]');
                        } else if (jqXHR.status == 500) {
                            alert(errmsg+'Internal Server Error [500].');
                        } else if (exception === 'parsererror') {
                            alert(errmsg+'Requested JSON parse failed.');
                        } else if (exception === 'timeout') {
                            alert(errmsg+'Time out error.');
                        } else if (exception === 'abort') {
                            alert(errmsg+'Ajax request aborted.');
                        } else {
                            alert(errmsg+'Uncaught Error.\n' + jqXHR.responseText);
                        }
                    }
                });	
			}
			function rs(binvono,einvono){
				$.ajax({
					url: "z_vccap01_rs.aspx?db="+q_db+"&binvono="+binvono+"&einvono="+einvono,
                    type: 'POST',
                    data: JSON.stringify(""),
                    dataType: 'text',
                    timeout: 10000,
                    success: function(data){
                    	try{
                    		tmp = JSON.parse(data);
                    		if(tmp.status==1){
                    			window.open("../htm/htm/"+tmp.filename);
                    		}else{
                    			alert(tmp.message);
                    		}
                    	}catch(e){
                    	}
                    },
                    complete: function(){
                    
                    },
                    error: function(jqXHR, exception) {
                        var errmsg = this.url+'資料讀取異常。\n';
                        if (jqXHR.status === 0) {
                            alert(errmsg+'Not connect.\n Verify Network.');
                        } else if (jqXHR.status == 404) {
                            alert(errmsg+'Requested page not found. [404]');
                        } else if (jqXHR.status == 500) {
                            alert(errmsg+'Internal Server Error [500].');
                        } else if (exception === 'parsererror') {
                            alert(errmsg+'Requested JSON parse failed.');
                        } else if (exception === 'timeout') {
                            alert(errmsg+'Time out error.');
                        } else if (exception === 'abort') {
                            alert(errmsg+'Ajax request aborted.');
                        } else {
                            alert(errmsg+'Uncaught Error.\n' + jqXHR.responseText);
                        }
                    }
                });	
			}
		</script>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div id="q_menu"></div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"></div>
			</div>
			<div class="prt" style="margin-left: -40px;">
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>
	</body>
</html>