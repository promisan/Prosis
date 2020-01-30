<!--- parameters --->


<cfoutput>
<link rel="stylesheet" type="text/css" href="#SESSION.root#/#client.style#">
</cfoutput>

<link rel="stylesheet" type="text/css" href="../../pkdb.css">
<HTML><HEAD>
    <TITLE>Library Content</TITLE>
</HEAD><BODY bgcolor="#FFFFFF">

<cfoutput>
<script>

function doit(subdir)

{
	if (confirm("Do you want to remove selected reports from your personal archive ?"))
	
	{
		
	listing.submit()
	
		
	}
	    
}


w = 0
h = 0
if (screen) 
{
w = #CLIENT.width# - 60
h = #CLIENT.height# - 110
}

function showfile(rt,fil,name,win)
{   

 	window.open(rt+ "/" + fil + "/" + name + "?id=" + win, "pdf", "left=35, top=35, width=" + w + ", height= " + h + ", status=yes,toolbar=yes, scrollbars=yes, resizable=yes");
}


ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight2";
	 }else{
		
     itm.className = "regular";		
	 }
  }



</script>

</cfoutput>

<cfset CLIENT.docdir = "#SESSION.rootPath#\rptFiles\PDFLibrary\">

<CFParam name="Attributes.DocumentURL" default="#SESSION.root#/rptFiles/PDFLibrary/">
<CFParam name="Attributes.DocumentPath" default="#SESSION.rootPath#\rptFiles\PDFLibrary/">
<CFParam name="Attributes.SubDirectory" default="#URL.ID#\\#SESSION.acc#">	
<CFParam name="URL.Filter" default="">	
<CFParam name="Attributes.Filter" default="#URL.Filter#">	
<CFParam name="URL.TODAY" default="0">	
<CFParam name="Attributes.Today" default="#URL.TODAY#">	
<CFParam name="Attributes.Insert" default="No">	
<CFParam name="Attributes.Remove" default="Yes">	
<CFParam name="Attributes.ShowSize" default="Yes">	
<CFParam name="Attributes.Highlight" default="yes">   <!--- hightlight document row --->
<CFParam name="Attributes.Listing" default="1">
<CFParam name="Attributes.Color" default="white">

<cfif DirectoryExists("#Attributes.DocumentPath#\#Attributes.SubDirectory#")>

        <!--- skip--->

<cfelse>    <cfdirectory action="CREATE" 
             directory="#Attributes.DocumentPath#\#Attributes.SubDirectory#">

</cfif>

<cfdirectory action="LIST" 
	directory="#Attributes.DocumentPath#\#Attributes.SubDirectory#" 
	name="GetFiles" 
	filter="#Attributes.Filter#*.*">
	
<cfif #Attributes.Listing# eq "1">	

<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#111111" style="border-collapse: collapse"> 

<CFSET Row = 0>

<cfquery name="GetFiles" dbtype="query">
SELECT *
	FROM   GetFiles
	ORDER BY DateLastModified DESC
</cfquery>

<cfform action="FileDelete.cfm" name="listing">

<cfoutput>
<input type="hidden" name="subdir" id="subdir" value="#Attributes.SubDirectory#">
<input type="hidden" name="path" id="path" value="">
</cfoutput>

<script language="JavaScript">
{
listing.path.value = window.location.href
}
</script>

<CFOUTPUT query="GetFiles">

    <cfif (#DateLastModified# gt #now()#-1 AND #Attributes.Today# eq "1") 
	    OR #Attributes.Today# eq "0">
		
    <tr>

   <td height="1" colspan="5"><img src="<cfoutput>#SESSION.root#</cfoutput>/Images/TableMidTop.gif" alt="" width="100%" height="6" border="0"></td>

    </tr>		

	<CFIF Type is "FILE">
		<cfif Attributes.Highlight eq "yes">
			<tr onMouseOver="hl(this,true)" onMouseOut="hl(this,false)" style="cursor: pointer;">
		<cfelse>
			<tr bgcolor="#Attributes.Color#">
		</cfif> 
		
	<td width="10%" height="25" valign="middle" onClick="javascript:showfile('#Attributes.DocumentURL#','#Attributes.Subdirectory#','#Name#','#RandRange(1, 100)#');">&nbsp;
				
	<CFSET SeparatorPos = Find( '.', Reverse(#Name#) )>

	<CFIF SeparatorPos is 0> <!--- separator not found --->
	<CFELSE>
		<CFSET FileExt = Right( #Name#, SeparatorPos - 1 )>
	</CFIF>		
    
	<cfloop index="Item" list="#Name#" delimiters="_">
	   		<cfif #Item# eq ".pdf">
			 <img src="#SESSION.root#/Images/pdf_small.jpg" alt="" width="18" height="17" 
			 border="0">
	        <cfelse>
			    <cfif #Item# eq ".doc">
    			  <img src="#SESSION.root#/Images/word_small.jpg" alt="" width="18" height="17" 
				  border="0">
			   </cfif>
			</cfif>   
	</cfloop>
	
		</td>

		
	<td width="55%" valign="middle" class="regular" onClick="javascript:showfile('#Attributes.DocumentURL#','#Attributes.Subdirectory#','#Name#','#RandRange(1, 100)#');">
		
	<table width="100%"><tr>
	<cfloop index="Item" list="#Name#" delimiters="_">
	   		<cfif #Item# neq ".pdf" and #item# neq ".doc"><td valign="middle" width="30%" class="regular">#Item#</td></cfif>
		</cfloop>
	</tr></table>	
	
	
	</td>
	
	<cfif #Attributes.ShowSize# eq "1">
    	<TD width="15%" class="regular"><cfset kb = #Size#/1024> #numberFormat(kb, "_____._" )# kb</TD>
    	<TD width="15%" nowrap class="regular">#DateFormat(DateLastModified, CLIENT.DateFormatShow)# #TimeFormat(DateLastModified, "HH:MM")#</TD>
	</cfif>
	
	<CFSET Row = Row + 1>
	
	<td align="right">
	<input type="checkbox" name="select" id="select" value="#Name#"></td>
		  	
	</TR>
	</CFIF>
	
	</cfif>
	
</CFOUTPUT>


<tr>

    <td height="1" colspan="3"><img src="<cfoutput>#SESSION.root#</cfoutput>/images/tablemidtop.gif" alt="" width="100%" height="6" border="0"></td>

    <cfif Attributes.Remove eq "yes" and Row gt "0">

    <td align="center">
	<cfoutput>
		<img src="#SESSION.root#/Images/trash.jpg" alt="" border="0" style="bordercolor: f6f6f6; cursor: pointer;" onClick="javascript:doit('#Attributes.Subdirectory#')">
	</cfoutput>
	</td>
	
	<cfelse>
	
	<td height="1" colspan="1"><img src="<cfoutput>#SESSION.root#</cfoutput>/images/tablemidtop.gif" alt="" width="100%" height="6" border="0"></td>
	
	</cfif>
	
	<td height="1" colspan="1"><img src="<cfoutput>#SESSION.root#</cfoutput>/Images/tablemidtop.gif" alt="" width="100%" height="6" border="0"></td>

</tr>
	
</cfform>	


</TABLE>
 
</cfif>

</BODY></HTML>