<cfparam name="URL.Class" default="">
<cfparam name="URL.ItemNo" default="">
<cfparam name="URL.Mission" default="">

<cfoutput>

<!--- Target of the form --->
<table class="hide"> <tr> <td> <iframe name="submitPicture" id="submitPicture"></iframe> </td> </tr> </table>

<table width="100%" align="center">


	
	<tr>
		<td>
		
			<FORM name     = "attach" id="attach"
			      action   = "ItemPictureSubmit.cfm?ItemNo=#URL.ItemNo#&Class=#Url.Class#&mission=#URL.Mission#"
				  method   = "post" 
				  target   = "submitPicture"
				  onsubmit = "return submitForm('#url.class#');"
				  enctype  = "multipart/form-data"
                  style    = "margin:0;padding: 5px 0; background:##efefef;">
				
				<table width="100%">						
								
					<tr>
					
						<td style="padding-left:5px" width="100px">
						  <input type = "file" 
						     name     = "uploadedfile_#url.class#" 
							 id       = "uploadedfile_#url.class#" 
							 style    = "font-size:13;width:auto;height:25px;border-radius:5px;background: none;" 
							 size     = "60" 
							 required = "yes"
							 accept   = "image/jpeg,image/png" 
							 class    = "regularxl">
						</td>
						
						<td align="left">
						
						<cf_tl id="Upload" var="vUpload">
						<input class   = "button10g" 
							   style   = "font-size:13;width:100px;height:25px;background: ##C83702;color:##FFFFFF;padding:3px 2px;border:none;border-radius:5px;" 
							   type    = "submit" 
							   name    = "upload" 
							   id      = "upload_#url.class#" 
							   value   = "#vUpload#">
							  
						</td>
						
						<td id="loader_#url.class#" class="hide" alig="left">
							<img src="#SESSION.Root#/images/busy9.gif">
						</td>
							
					</tr>

				</table>
				
			</form>	

		</td>
	</tr>
    <tr>
		<td id="images_#URL.Class#">
			<cfinclude template="ItemPictureView.cfm">
		</td>
	</tr>
</table>
	  
</cfoutput>