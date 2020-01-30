<cfset openas = "view"> 	

<cfparam name="DocumentServerIsOp" default="0">

<cfoutput>
					
<cfif FindNoCase(".pdf", "#NameShow#")> 			
	  <img src="#SESSION.root#/Images/pdf_button.png" align="absmiddle" alt="Open attachment" border="0" align="center">			  

<cfelseif FindNoCase(".swf", "#NameShow#")>			  
	  <img src="#SESSION.root#/Images/flash_paper.gif" align="absmiddle" alt="Open Flash paper" border="0" align="center">

<cfelseif FindNoCase(".cfm", "#NameShow#")>			  
	  <img src="#SESSION.root#/Images/cf_cfm.gif" align="absmiddle" alt="Coldfusion Template" border="0" align="center">  
	  
	  <cfif Remove eq "yes">
		  <cfset openas = "edit"> 
	  <cfelse>
	  	  <cfset openas = "read"> 
	  </cfif>	
	  
<cfelseif FindNoCase(".cfc", "#NameShow#")>			  
	  <img src="#SESSION.root#/Images/cf_cfm.gif" align="absmiddle" alt="Coldfusion Template" border="0" align="center">  
	  
	  <cfif Remove eq "yes">
		  <cfset openas = "edit"> 
	  <cfelse>
	  	  <cfset openas = "read"> 
	  </cfif>			  
	  
<cfelseif FindNoCase(".htm", "#NameShow#")>			  
	  <img src="#SESSION.root#/Images/note.gif" align="absmiddle" alt="Coldfusion Template" border="0" align="center">  
	  
	  <cfif Remove eq "yes">
		  <cfset openas = "edit"> 
	  <cfelse>
	  	  <cfset openas = "read"> 
	  </cfif>		  	  
	 
<cfelseif FindNoCase(".txt", "#NameShow#")>			  
	 
	  <img src="#SESSION.root#/Images/note.gif" align="absmiddle" alt="Text File" border="0" align="center">  				  				  
	  
	  <cfif Remove eq "yes">
		  <cfset openas = "edit"> 
	  <cfelse>
	  	  <cfset openas = "read"> 
	  </cfif>	  

<cfelseif FindNoCase(".cfr", "#NameShow#")>			  
	  <img src="#SESSION.root#/Images/report5.gif" align="absmiddle" alt="Coldfusion Report" border="0" align="center">  					  

<cfelseif FindNoCase(".jpg", "#NameShow#")>			  					
	   <img src="#SESSION.root#/Images/file_image.jpg" align="absmiddle" alt="Open Image" height="15" width="13" border="0" align="center">
	   
<cfelseif FindNoCase(".zip", "#NameShow#")>			  
	  <img src="#SESSION.root#/Images/winzip.gif" align="absmiddle" alt="Coldfusion Template" border="0" align="center">  

<cfelseif FindNoCase(".gif", "#NameShow#")>			  
	   <img src="#SESSION.root#/Images/file_image.jpg" align="absmiddle" alt="Open Image" height="15" width="13" border="0" align="center">

<cfelseif FindNoCase(".doc", "#NameShow#")>			  
	   <img src="#SESSION.root#/Images/word_small.gif" align="absmiddle" alt="Open Word attachment" border="0" align="center">		  			

<cfelseif FindNoCase(".wpd", "#NameShow#")>			  
	   <img src="#SESSION.root#/Images/wordperfect_small.gif" align="absmiddle" alt="Open Word attachment" border="0" align="center">		  							   

<cfelseif FindNoCase(".xls", "#NameShow#")>
	  <img src="#SESSION.root#/Images/excel.gif" height="12" width="12" align="absmiddle" alt="Open Excel attachment" border="0" align="center">

<cfelseif FindNoCase(".qpw", "#NameShow#")>
	  <img src="#SESSION.root#/Images/excel.gif" align="absmiddle" alt="Open Excel attachment" border="0" align="center">		   				   

<cfelse>
	<cfif DocumentServerIsOp eq "0">
	  <img src="#SESSION.root#/Images/note.gif" align="absmiddle" alt="Open document"   border="0" align="center">		
	<cfelse>
	 <img src="#SESSION.root#/Images/documentserver.png" align="absmiddle" alt="Open document"   border="0" align="center">	
	</cfif>  

</cfif>					

</cfoutput>