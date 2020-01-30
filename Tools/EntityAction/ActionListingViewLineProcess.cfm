
<cfparam name="ActionProcess" default="Do it">

<cfset proctext = "#ActionProcess#">
<cfif proctext eq "">
	<cfset proctext = "Do it">
</cfif>

<cfoutput>  


 <cfif EnableQuickProcess eq "1">
 
 	<cfif ActionStatus eq "0" and EntityAccess eq "EDIT" and Action eq "1">
					 
		<td height="35" id="quick#ActionId#" name="quick#ActionId#" class="Procets-R-W">
				
		<cfif attributes.hideprocess eq "0" and actionTrigger eq "" and object_op is 1>
		
			<input type="checkbox" class="radiol" name="confirmwf" id="confirmwf" style="display:none;" value="#ActionId#" checked onclick="toggleaction('#ActionId#')">		
		    <a class="Procets" id="d#ActionId#" href="javascript:submitwfquick('#ActionId#','#attributes.ajaxid#')">#proctext#</a>  
			
		 </cfif>	
	
	 	</td>
		
	</cfif>
	
 <cfelse>

  				
	 <cfif object_op is 1 and Action eq "1" and (EntityAccess eq "EDIT" or EntityAccess eq "READ")>
	 			
		 <td align="center" height="35" class="Procets-R-W">
				
			<cfif attributes.hideprocess eq "0" and actionTrigger eq "" and showaction is 1>
		
			    <cfif Dialog.DocumentMode eq "Popup" and DisableStandardDialog eq "1" >
				
				   <cfif EntityAccess eq "EDIT">
					  <a class="Procets" href="javascript:#Dialog.DocumentTemplate#('#ActionCode#','#ActionId#')">#proctext#</a>
					</cfif>   
															
				<cfelse>
				
					<cfif Attributes.Subflow eq "No">
						<a class="Procets" href="javascript:process('#ActionId#','#attributes.preventProcess#','#Attributes.ajaxid#','#ProcessMode#')">#proctext#</a>
					<cfelse>														   						
						<a class="Procets" href="javascript:process('#ObjectId#','#attributes.preventProcess#','#Attributes.ajaxid#','#ProcessMode#')">#proctext#</a>							   
					</cfif>	   								 						
				
				</cfif>
	
			</cfif>
		</td>
	                       
	  </cfif>

  </cfif> 
	  
</cfoutput>