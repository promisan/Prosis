<input type="hidden" name="attachmentid" value="" id="attachmentid">	
 
<cfset i = first>	
<cfoutput>
<cfloop query="searchresult">

	<cfif url.engine eq "advanced">
	
		<cfset Collection.CollectionTemplate = "null">
		
	</cfif>

	<cfif len(custom1) eq "36">
	  <cfset resultclass = "document">
	<cfelse>
	  <cfset resultclass = "data">
	</cfif>    
					
	<!--- hide the logging results, but better not to scan these --->
			
		<cfif resultclass eq "document">
		
			<!--- check how / this exists --->
		
			<table border="0" width="100%" cellspacing="0" cellpadding="0" id="resultset" name="resultset"
				 onMouseOver = "this.className= 'highlight';on_the_fly_preview('document','#custom1#','#currentrow-1#');" 								
				 onClick     = "do_viewdocument('#custom1#','0','#rowguid#');"
				 class       = "formpadding">
												 
		<cfelse>
		
			<table border="0" width="100%" cellspacing="0" cellpadding="0" id="resultset" name="resultset"
				 onMouseOver= "this.className= 'highlight';on_the_fly_preview('element','#key#','#currentrow-1#');" 								
				 onClick    = "do_viewelement('#key#','#rowguid#','#Category#');"
				 class      = "formpadding">							
			
		</cfif>
		
		<tr>

		  <td width="1%"><b>#i#&nbsp;</b><cfset i = i + 1></td>
		 					  
			<cfif resultclass eq "document">
			
				<cfset vNormalizedPath = ReReplace(url,"/[0-9a-zA-Z]{8}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{12}/","","ALL")>
				
				<cfif left(vNormalizedPath,1) eq "_">
					
					<cfset l = len(vNormalizedpath)>
					<cfset vNormaliZedPath = mid(vNormalizedPath,  2,  l-1)>					
					
				</cfif>
		
				<td>					
				   <table cellspacing="0" cellpadding="0" class="formpadding">
				    <tr><td align="center">
					<a href="##" onClick="do_viewdocument('#custom1#','1','#rowguid#');"><font size="3" color="007EFD">#vNormalizedPath#</b></font></a>
					</td>
					<td width="21" align="center">
														
					<img src="#SESSION.root#/Images/preview_faded.png" 
					  alt="preview one page of the document" 
					  name="preview_normal" class="regular"
					  onClick="do_viewdocument('#custom1#','1','#rowguid#');do_select('preview_auto');"
					  border="0" 
					  align="absmiddle"> 	
					  
					  <img src="#SESSION.root#/Images/preview.png" 
					  alt="preview one page of the document" 
					  name="preview_auto" class="hide"
					  onClick="do_viewdocument('#custom1#','1','#rowguid#');do_select('preview_normal')"
					  border="0" 
					  align="absmiddle"> 	
					  							 						
					
					</td>
					
					<td width="21" align="center">									
					<a href="##" onClick="get_file('#custom1#');">									
					<img src="#SESSION.root#/Images/document1.gif" alt="Open document" border="0" align="absmiddle"> 								
					</a>												
					</td>
					</tr>
					</table>
				</td>	
				
			<cfelse>
			
				<!--- this is a data element and not a document --->
				
				<td>
				<table cellspacing="0" cellpadding="0" class="formpadding">
			    <tr>
				
				<td>									
					
						<a href="##" onClick="javascript:do_viewelement('#key#','#rowguid#','#Category#');">
							<font size="3" color="0080C0">#title# : #custom1#</font> <font size="2" color="0080C0">[#custom2#]</b></font>							
						</a>
					
				</td>
				<td width="21" align="center">
														
					<img src="#SESSION.root#/Images/preview_faded.png" 
					  alt="preview one page of the document" 
					  name="preview_normal" 
					  class="regular" 
					  onClick="do_viewelement('#key#');do_select('preview_auto')" 
					  border="0" 
					  align="absmiddle"> 	
					  
					  <img src="#SESSION.root#/Images/preview.png" 
					  alt="preview one page of the document" 
					  name="preview_auto" 
					  class="hide" 
					  onClick="do_viewelement('#key#');do_select('preview_normal')" 
					  border="0" 
					  align="absmiddle"> 	
					 								
				</td>																
																			
				</table>
				</td>								
				
			</cfif>	
			
		  <td width="1%">&nbsp;</td>				  
		</tr>
		
		<!--- show the result of the search body --->
		
		<cfif resultclass eq "document" or Collection.CollectionTemplate eq "">
		
		<tr>
		  <td></td>
		  <td valign="top">
			  <table width="94%" cellspacing="0" cellpadding="0" class="formpadding">			
			      <!---
			      <cfif custom1 neq "">					 
					  <tr><td><font size="2">#custom1#</font></td></tr>									
				  </cfif>
				  --->
				  <tr><td><font face="Verdana">#context#</font></td></tr>	  						
				  
				  <tr id="#currentrow#_summary" class="hide"><td><font size="1" color="004000">#summary#</td></tr>

			  </table>
		  </td>				 
		</tr>
		
		<cfelse>	
		
		<tr>
		  <td></td>
		  <td valign="top">
		  
		  <table width="95%" align="center">		
		  
			  <cfif  url.engine eq "collection">
			  
					  <!--- preview the element data --->					  
					  <cfset l = len(Collection.CollectionTemplate)>		
					  <cfset path = left(Collection.CollectionTemplate,l-4)>	
					  <cfinclude template="../../#path#Preview.cfm">		
					  			
			  <cfelse>
			  							  
			  		<cfinclude template="../../CaseFile/Application/Element/View/ElementViewPreview.cfm">	
					
			  </cfif>
		  
		  </table>
		  </td>
		</tr>  
														
		</cfif>
		
		<!---
		
		<cfif Custom3 neq "" or Custom4 neq "">
		<tr height="10">
			  <td></td>
			  <td valign="top">
				
				<TABLE width="95%" align="center">		
				    <TR>		
				    <TD width="25%">
						<cfif Custom3 neq "">
						<font face="Verdana" size="2" color="gray">To:</font>
						</cfif>
					</TD>
				    <TD width="25%"><font face="Verdana" size="2">
						<cfloop list="#Custom3#" index="element">
						#Element# <br>
						</cfloop>
						</font>
					</TD>
					<TD width="25%">
						<cfif Custom4 neq "">
							<font face="Verdana" size="2" color="gray">From:</font>
						</cfif>	
					</TD>
				    <TD width="25%"><font face="Verdana" size="2">
						<cfloop list="#Custom4#" index="element">
						#Element# <br>
						</cfloop>
						</font>
					</TD>
					</TR>	
				</TABLE>
				</td>
		</tr>	
		</cfif>		
		
		--->						
		
		<tr height="3"><td colspan="2"></td></tr>									
	
</cfloop>	
</cfoutput>
