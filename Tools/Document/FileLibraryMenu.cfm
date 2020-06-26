<cfoutput>
<CFParam name="Attributes.Label" default="Attach">
<cfsavecontent variable="selectme">
        style="height:20;cursor: pointer;border: 1px solid d4d4d4"
		onMouseOver="this.className='highlight1'"
		onMouseOut="this.className='regular'"
</cfsavecontent>

	<table border="0" cellspacing="0" cellpadding="0">
	
			<tr>	
			
			<cfif list eq "regular" and DocumentServer eq "No" and showsize eq "1">
			
			    <cfif mode neq "Report">
			
				<td width="60" align="center" id="folder_select" 
				onclick="viewfiles('#mode#','#host#','#DocumentPath#','#Subdirectory#','#Filter#')" #selectme#>
					<table cellspacing="0" cellpadding="0"><tr><td style="padding-left:4px">
					<img src="#SESSION.root#/Images/Folder.png" width="24" height="24"
					     alt="Listing" 
						 border="0" 
						 align="absmiddle">
					 </td><td style="padding-left:4px;padding-right:8px" class="labelit"><cf_tl id="Listing"></td>
					 </tr></table>
			    </td>
										
				<td width="1">|</td>		
				
				</cfif>
				
				<td width="60" align="center" id="mail_select" 
				onclick="mailfiles('#mode#','#host#','#DocumentPath#','#Subdirectory#','#Filter#')" #selectme#>
				<table cellspacing="0" cellpadding="0"><tr><td style="padding-left:4px">
				<img src="#SESSION.root#/Images/Mail.png"  width="24" height="24"
				     alt="Insert document" 
					 border="0" 
					 align="absmiddle">
				 </td><td style="padding-left:4px;padding-right:8px" class="labelit"><cf_tl id="Mail"></td>
					 </tr></table>	 
				
			    </td>
				
				<td width="1">|</td>		
						
			</cfif>
			

					<td id="attach" align="center" width="110" 
					onclick="addfile('#mode#','#host#','#DocumentPath#','#Subdirectory#','#Filter#','#attbox#','1','No','#attachdialog#','#pdfscript#')" #selectme#>
						 <table cellspacing="0" cellpadding="0"><tr><td style="padding-left:4px">
						
						
						 <img src="#SESSION.root#/Images/Attach.png" width="24" height="24"
						 alt="Attach document" 
						 border="0" 
						 align="absmiddle">
						  </td><td style="padding-left:4px;padding-right:8px" class="labelit"><cf_tl id="#Attributes.Label#"></td>
						 </tr></table>
						
				    </td>

				<cfif DocumentServer neq "No">
						<td id="attach" align="center" width="110" 
						onclick="addfile('#mode#','#host#','#DocumentPath#','#Subdirectory#','#Filter#','#attbox#','1','#DocumentServer#','#attachdialog#','#pdfscript#')" #selectme#>
							 <table cellspacing="0" cellpadding="0"><tr><td style="padding-left:4px">
							
							
							 <img src="#SESSION.root#/Images/Attach.png" width="24" height="24"		     
							 alt="Attach document" 
							 border="0" 
							 align="absmiddle">
							  </td><td style="padding-left:4px;padding-right:8px" class="labelit"><cf_tl id="Document Server"></td>
							 </tr></table>
							
					    </td>

				</cfif>
				
			</tr>
	
	</table> 		

</cfoutput>	