<cf_param name="url.mode" default="" type="string">
<cf_param name="url.dir"  default="" type="string">
<cf_param name="url.sub"  default="" type="string">

<cfif find ("Chrome","#CGI.HTTP_USER_AGENT#") 
	or find ("Firefox","#CGI.HTTP_USER_AGENT#") 
	or find ("Safari","#CGI.HTTP_USER_AGENT#")				
	or find ("MSIE 9","#CGI.HTTP_USER_AGENT#")
	or find ("MSIE 10","#CGI.HTTP_USER_AGENT#")
	or (
	      find("Mozilla/5.0","#CGI.HTTP_USER_AGENT#") and 
		  find("Trident","#CGI.HTTP_USER_AGENT#") and 
		  find("rv:11","#CGI.HTTP_USER_AGENT#") and 
		  find("like Gecko","#CGI.HTTP_USER_AGENT#")
		  
		)>	  

	<!DOCTYPE html>
	
<cfelse>

	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

</cfif>

<html>
<head>

	<title>Document Listing</title>	
			
	<cfoutput>
	
	<script>
		function showfile(name) {   		
		    window.right.location = "DocumentViewDetail.cfm?mode=#url.mode#&dir=#url.dir#&sub=#url.sub#&name="+name;			
		}
	</script>
	
	<script type="text/javascript" src="#SESSION.root#/scripts/jquery/jquery.js"></script> 
	<script type="text/javascript" src="#SESSION.root#/scripts/jquery/jquery.easing.1.3.js"></script> 
	
	<cf_layoutscript>
	
	</cfoutput>
	
	<style>
	
		html, body {
			height: 100%;
			width:100%;
			margin:0px;
		}
	
		#cf_layoutareadoc {
			height:100%; 
			width:100%
			}
			
		#ext-gen6 {
			background: -moz-linear-gradient(top,  rgba(235,241,246,1) 0%, rgba(171,211,238,1) 50%, rgba(137,195,235,1) 51%, rgba(213,235,251,1) 100%); /* FF3.6+ */
			background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(235,241,246,1)), color-stop(50%,rgba(171,211,238,1)), color-stop(51%,rgba(137,195,235,1)), color-stop(100%,rgba(213,235,251,1))); /* Chrome,Safari4+ */
			background: -webkit-linear-gradient(top,  rgba(235,241,246,1) 0%,rgba(171,211,238,1) 50%,rgba(137,195,235,1) 51%,rgba(213,235,251,1) 100%); /* Chrome10+,Safari5.1+ */
			background: -o-linear-gradient(top,  rgba(235,241,246,1) 0%,rgba(171,211,238,1) 50%,rgba(137,195,235,1) 51%,rgba(213,235,251,1) 100%); /* Opera 11.10+ */
			background: -ms-linear-gradient(top,  rgba(235,241,246,1) 0%,rgba(171,211,238,1) 50%,rgba(137,195,235,1) 51%,rgba(213,235,251,1) 100%); /* IE10+ */
			background: linear-gradient(to bottom,  rgba(235,241,246,1) 0%,rgba(171,211,238,1) 50%,rgba(137,195,235,1) 51%,rgba(213,235,251,1) 100%); /* W3C */
			filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ebf1f6', endColorstr='#d5ebfb',GradientType=0 ); /* IE6-9 */
			}
			
		.label {
			font-family:Calibri,Trebuchet MS, Helvetica; 
			font-size:12px; 
			color:#454545; 
			padding-left:5px; 
			padding-right:5px
			}
		
		.container:hover {
			border:1px solid gray;
			cursor:pointer;
			-webkit-box-shadow:  0px 0px 10px 2px silver;        
      		box-shadow:  0px 0px 10px 2px silver;
			}
			
		.container {
			height:50px; 
			width:100px;
			border:1px solid silver;
			background: -moz-linear-gradient(top,  rgba(255,255,255,1) 0%, rgba(243,243,243,1) 50%, rgba(237,237,237,1) 51%, rgba(255,255,255,1) 100%); /* FF3.6+ */
			background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(255,255,255,1)), color-stop(50%,rgba(243,243,243,1)), color-stop(51%,rgba(237,237,237,1)), color-stop(100%,rgba(255,255,255,1))); /* Chrome,Safari4+ */
			background: -webkit-linear-gradient(top,  rgba(255,255,255,1) 0%,rgba(243,243,243,1) 50%,rgba(237,237,237,1) 51%,rgba(255,255,255,1) 100%); /* Chrome10+,Safari5.1+ */
			background: -o-linear-gradient(top,  rgba(255,255,255,1) 0%,rgba(243,243,243,1) 50%,rgba(237,237,237,1) 51%,rgba(255,255,255,1) 100%); /* Opera 11.10+ */
			background: -ms-linear-gradient(top,  rgba(255,255,255,1) 0%,rgba(243,243,243,1) 50%,rgba(237,237,237,1) 51%,rgba(255,255,255,1) 100%); /* IE10+ */
			background: linear-gradient(to bottom,  rgba(255,255,255,1) 0%,rgba(243,243,243,1) 50%,rgba(237,237,237,1) 51%,rgba(255,255,255,1) 100%); /* W3C */
			filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f3f3f3', endColorstr='silver',GradientType=0 ); /* IE6-9 */
			-webkit-border-radius: 1px;
			border-radius: 1px;
			}
		
	</style>
	
</head>

<body>
<!--- ------------------------------------------ --->
<!--- Listing of the documents in a listing mode --->
<!--- ------------------------------------------ --->


<cfoutput>

<cfset host = replace(url.host,"|","\","ALL")> 	

<!--- determine the root --->

<cfif url.mode eq "Report">
	<cfset rt = "">	
<cfelse>
	<cfset rt = "#host#">
</cfif>		



<!--- correct the passing of the path --->
<cfset dir = replaceNoCase(url.dir,"|","\","ALL")> 	

	<cfset attrib = {type="Border",name="att",fitToWindow="yes"}>			
	
	<cf_layout attributeCollection="#attrib#">	
			
	<cf_layoutarea 
          position="top"
          name="controltop"
		  size="90"      
		  maxsize="90"
		  minsize="90"  
          splitter="true"
		  overflow="auto">		
		  
		 						
		<cfdirectory action="LIST" 
			directory="#rt#\#dir#\#url.sub#" 
			name="GetFiles" 
			sort="DateLastModified DESC" 
			filter="#url.fil#*.*">
								
			<table width="98%" align="center" cellspacing="0" cellpadding="0">		
			
				<tr>
				<cfloop query="GetFiles">
					
					<td style="padding:15px 3px 5px 3px" align="center">
						<table cellpadding="0" cellspacing="0" class="container" align="center" onclick="showfile('#name#')">
							<tr>
								<td width="20" height="19" style="padding-left:4px">
					
								<CFSET SeparatorPos = Find( '.', Reverse("#Name#") )>
								<cfset x = len(name)>
								<cfset y = find('_', name)>							
								<cfset nameshow = right(name, x-y)>
								
								<cfif FindNoCase(".pdf", "#NameShow#")> 	
									<img src="#SESSION.root#/Portal/Images/icons/PDFIcon.png">				  
							   	<cfelseif FindNoCase(".jpg", "#NameShow#") or FindNoCase(".png", "#NameShow#")>			
									<img src="#SESSION.root#/Portal/images/icons/JPGIcon.png">
							   	<cfelseif FindNoCase(".gif", "#NameShow#")>		
									<img src="#SESSION.root#/Portal/images/icons/GIFIcon.png">	  
							   	<cfelseif FindNoCase(".doc", "#NameShow#") or FindNoCase(".docx", "#NameShow#")>	
									<img src="#SESSION.root#/Portal/images/icons/WordIcon.png">		  	  				  							   
								<cfelseif FindNoCase(".xls", "#NameShow#") or FindNoCase(".xlsx", "#NameShow#")>
									<img src="#SESSION.root#/Portal/images/icons/ExcelIcon.gif">
								<cfelseif FindNoCase(".ppt", "#NameShow#") or FindNoCase(".pptx", "#NameShow#") or FindNoCase(".pps", "#NameShow#")>
									<img src="#SESSION.root#/Portal/images/icons/PowerPointIcon.png">	   				   
								<cfelse>
									<img src="#SESSION.root#/Portal/images/icons/FileIcon.png">	
								</cfif>		
								</td>
								
								<td class="label">			
									 
									  <cfquery name="Attachment" 
										 datasource="AppsSystem"
										 username="#SESSION.login#" 
										 password="#SESSION.dbpw#">
									     SELECT    TOP 1 *
										 FROM      Attachment
										 WHERE     Reference = '#url.sub#' 
										 AND       FileName = '#Name#'						
										 ORDER BY Created DESC
										 </cfquery>
										 
										<cfif attachment.recordcount eq "1">
											
												#nameshow#
										
										<cfelse>
								
											#nameshow#
										
										</cfif> 
										
								</td>
							</tr>
						</table>
					</td>		
					
				</cfloop>
				</tr>			
			
			</table>
								 
	</cf_layoutarea>		
		
	<cf_layoutarea position="center" name="doc" style="overflow:hidden">	
	
		<iframe name="right"
        	id="right"
			style="width:100%; height:100%; overflow:hidden; border:0px; background-color:white;"
        	frameborder="0"></iframe>
			
	</cf_layoutarea>	
	
	</cf_layout>

</cfoutput>

</body>
</html>
