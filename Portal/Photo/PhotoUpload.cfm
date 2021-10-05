<cf_tl id="My Picture" var="vTitle">

<cf_param name="url.mode"     			default="user" 			type="string">
<cf_param name="url.fileName" 			default="#session.acc#" type="string">
<cf_param name="url.pictureDialog"     	default="picturedialog" type="string">
<cf_param name="url.widmodalbg"     	default="widmodalbg" 	type="string">
<cf_param name="url.Pic"     			default="Pic" 			type="string">
<cf_param name="url.title"     			default="#vTitle#" 		type="string">
<cf_param name="url.width" 				default="54px" 			type="string">
<cf_param name="url.height" 			default="44px" 			type="string">
<cf_param name="url.destination"		default="EmployeePhoto" type="string">
<cf_param name="url.style"				default="" 				type="string">

<table class="photoupload" style="width:100%">
	<tr>
	
		<td style="padding-left:10px;padding-top:10px">
		
		<table width="100%">
			<tr><td class="labellarge"><cfoutput>#url.title#:</cfoutput></td>	
				<cfoutput>	
					<td align="right" style="cursor:pointer;padding-right:7px" 
					  onclick="$('###url.pictureDialog#').slideUp(200); $('###url.widmodalbg#').css('display','none');">
					  <img width="25" height="25" src="#SESSION.root#/images/close.png" alt="" border="0">
				    </td>
				</cfoutput>		
			</tr>
		</table>		
			
		</td>
		
	</tr>
		
	<tr>
		<td class="linedotted"></td>
	</tr>

	<tr class="hide">
		<td align="center" height="50">	
			<iframe name="signaturebox"
				id="signaturebox"
				width="100%"
				height="100%"
				frameborder="0">
			</iframe>	
		</td>
	</tr>
	
	<tr>
		<td class="labelit" style="padding-left:20px;color:#808080" align="center">			
			<cf_tl id="Images should be JPG format with 4:3 ratio"> (150px * 120px <cf_tl id="approx">.)			
		</td>
	</tr>
	
	<tr>
		<td align="center" id="photoshow" style="height:170">
						
			<cfinclude template="PhotoUploadView.cfm">
			
	</td></tr>
	
	<tr>
		<td class="linedotted"></td>
	</tr>
	
	<cfajaxproxy cfc="Service.Process.System.UserController" jsclassname="systemcontroller">
		
	<script language="JavaScript">
	
	function checkfile() {	
		var uController = new systemcontroller();								
		document.attach.action = document.attach.action + '&mid='+ uController.GetMid();						
		}
		
	</script>
	
	<tr>
		<td align="center" style="padding-top:5px">
				
			<cfoutput>
			
			<form name="attach" 
			      action="#session.root#/Portal/Photo/PhotoUploadSubmit.cfm?mode=#url.mode#&filename=#url.fileName#&Pic=#url.Pic#&width=#url.width#&height=#url.height#&destination=#url.destination#&style=#url.style#" method="post" 
			      target="signaturebox" 
				  enctype="multipart/form-data"				   
				  onSubmit="return checkfile()">
			
				<table>
					<tr>
					  <td>
					    <table><tr>
						<td bgcolor="f4f4f4" style="padding:3px;border:0px solid silver">
																		
							<input type="file" 
							   name="UploadedFile" id="UploadedFile" 
							   size="40" accept="image/jpeg" 
							   onChange="ptoken.navigate('#session.root#/Portal/Photo/PhotoCheck.cfm?source='+this.value,'submitbox')"
							   style="font-size:13px;border:1px solid silver; background-color:white">
						
						</td>
						</tr>
						</table>
					   </td>
					</tr>
					  
					<tr>				   
					   <td align="center" style="padding-top:4px">
					   					   
						   <table align="center" class="formspacing">
						     <tr>						   
						   	 <td>	
							 
								<cfoutput>
									<cfif FileExists("#SESSION.rootDocumentpath#\#url.destination#\#url.fileName#.jpg")>	
										<cf_tl id="Remove Picture" var="1">
										<input type="submit" name="Delete" style="border:1px solid silver;font-size:13px;width:170;height:27" id="Delete" value="#lt_text#" 
										  class="photoupload button10g">
									</cfif>
								</cfoutput>
							</td>	
							  <td id="submitbox">
							  
							 </td>
							</tr>
						   </table>
					   </td>
					</tr> 				
					
				</table>
			
			</form>
			
			</cfoutput>
			
		</td>
	</tr>
		
</table>
