<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

   <!--- filter --->
<table width="100%" cellspacing="0" cellpadding="0">
   <tr><td>
	<table cellspacing="0" cellpadding="0">
	   <tr>
	   
	    <td height="22" style="padding-right:6px">
	   
	     <cfoutput>
		
			 <cfif filter.recordcount eq "0">	
			   		
				<img src="#SESSION.root#/Images/select4.gif" alt="" 
				id="moreExp" border="0" class="regular" 
				align="absmiddle" style="cursor: pointer;" 
				onClick="more('more')">
				
				<img src="#SESSION.root#/Images/arrowdown.gif" 
				id="moreMin" alt="" border="0" 
				align="absmiddle" class="hide" style="cursor: pointer;" 
				onClick="more('more')">
				
			 <cfelse>
			 
			   <img src="#SESSION.root#/Images/select4.gif" alt="" 
				id="moreExp" border="0" class="hide" 
				align="absmiddle" style="cursor: pointer;" 
				onClick="more('more')">
				
				<img src="#SESSION.root#/Images/arrowdown.gif" 
				id="moreMin" alt="" border="0" 
				align="absmiddle" class="regular" style="cursor: pointer;" 
				onClick="more('more')">				 
			 
			 </cfif>	
		 
		 </cfoutput>	
			
		</td>
		
		<cfparam name="URL.Filter" default="{00000000-0000-0000-0000-000000000000}">
					
		<cfquery name="Filter" 
		datasource="AppsTransaction">
		    SELECT *
		    FROM   stCacheFilter
			WHERE  DocumentId = '#URL.FilterId#'
		</cfquery>	
			
		<td id="moreExpT" class="labellarge">
			<a href="javascript:more('more')"><font color="0080C0"><cf_tl id="Filter on data"></a>
		</td>
				
		</tr>
	</table>
  </td>
  </tr>
   						
  <cfif filter.recordcount eq "0">							  
  <tr id="more" class="hide">
  	<td><cfinclude template="MandateFilter.cfm"></td>
  </tr>
  <cfelse>
   <tr id="more" class="regular">
  	<td><cfinclude template="MandateFilter.cfm"></td>
  </tr>
  </cfif>
  
			   		   
</table>
	   
