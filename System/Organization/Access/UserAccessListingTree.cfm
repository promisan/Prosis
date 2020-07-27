
<table width="100%" height="100%" border="0" align="center">
<tr><td height="5"></td></tr>

<tr><td height="35">

<table width="99%" align="center">
<tr>

	<cfoutput>
	 
	  <td width="175" height="20" bgcolor="white" style="border: 1px solid Silver;">	
	  
	  <table><tr><td>
  
	  <input type="text"
       name="find"
	   id="find"
       size="25"
	   value="#URL.search#"
	   onClick="javascript:clearno()" onKeyUp="javascript:search()"
       maxlength="25"
       class="regular3">
	   
	   </td>
	   
	   <td style="padding-left:2px;padding-right:2px">
	 	   
	    <img src="#SESSION.root#/Images/search.png" 
		  alt         = "Search" 
		  name        = "locate" 
		  height      = "22"
		  width       = "20"
		  onMouseOver = "document.locate.src='#SESSION.root#/Images/contract.gif'" 
		  onMouseOut  = "document.locate.src='#SESSION.root#/Images/search.png'"
		  style       = "cursor: pointer;" 
		  border      = "0" 
		  align       = "absmiddle" 
		  onclick     = "reload(find.value)">
		  
		  </td></tr></table> 
	 
	  </td> 
	
	<td align="right"></td></tr>
	
	</cfoutput>  

</table>

</td></tr>

<tr>	
   	<td id="treedet" style="height:100%" valign="top">	
	   <cf_divscroll>	   
	   <cfinclude template="UserAccessListingTreeDetail.cfm">		
	   </cf_divscroll>
	</td>	   
</TR>

</table>