  
<cfparam name="url.parent" default="">

<cfset linkpass = url.link>
<cfset link    = replace(url.link,"||","&","ALL")>

<cfquery name="SearchResult" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM Organization
	WHERE Mission     = '#url.mission#'
	AND   MandateNo   = '#url.mandate#'
	<cfif url.parent neq "">
	AND ParentOrgUnit = '#URL.Parent#'
	<cfelse>
	AND (ParentOrgUnit = '' or ParentOrgUnit is NULL or Autonomous = 1)	
	</cfif>
ORDER BY HierarchyCode
</cfquery>

<table width="100%" class="navigation_table">

	<cfoutput query="SearchResult">
	
		<tr style="height:15px" class="navigation_row">
		  
		  <td width="30">	  
		  
			<cfquery name="Check" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT TOP 1 *
			    FROM Organization
				WHERE Mission     = '#url.mission#'
				AND   MandateNo   = '#url.mandate#'
				AND ParentOrgUnit = '#OrgUnitCode#'
			</cfquery>
			
			<cfif check.recordcount eq "1">
		  
				<img src="#SESSION.root#/Images/arrowright.gif" alt="Unit" 
					id="#orgunitcode#Exp" border="0" class="show" 
					align="middle" style="cursor: pointer;" 
					onClick="document.getElementById('#orgunitcode#Min').className='regular';document.getElementById('#orgunitcode#Exp').className='hide';document.getElementById('box#orgunitcode#').className='regular';ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Tree/TreeResult.cfm?close=#url.close#&box=#url.box#&des1=#url.des1#&link=#linkpass#&mission=#url.mission#&mandate=#url.mandate#&parent=#orgunitcode#','i#orgunitcode#')">
						
				<img src="#SESSION.root#/Images/arrowdown.gif" 
					id="#orgunitcode#Min" alt="Hide criteria" border="0" 
					align="middle" class="hide" style="cursor: pointer;" 
					onClick="document.getElementById('#orgunitcode#Min').className='hide';document.getElementById('#orgunitcode#Exp').className='regular';document.getElementById('box#orgunitcode#').className='hide'"> 
					
			</cfif>	
						
		  </td>
		  
		  <td  
			width="30" 
			onclick="javascript:ptoken.navigate('#link#&action=insert&#url.des1#=#orgunit#','#url.box#');<cfif url.close eq 'Yes'>ProsisUI.closeWindow('dialog#url.box#')</cfif>">&nbsp;
				 				   
			   <img src="#SESSION.root#/Images/bullet.png" alt="Select"
			     name="img98_#orgunit#" 
				 onMouseOver="document.img98_#orgunit#.src='#SESSION.root#/Images/button.jpg'" 
			     onMouseOut="document.img98_#orgunit#.src='#SESSION.root#/Images/bullet.png'"
				 id="img98_#orgunit#" 
				 width="12" 
				 style="cursor: pointer;"
				 height="12" 
				 border="0" 
				 align="absmiddle">					
		
			</td>
			<td width="100" class="cellcontent">#HierarchyCode#</td>
			<TD width="70%" class="cellcontent">#OrgUnitName#</TD>
		</tr>		
		<tr class="line"><td colspan="4" class="hide" id="box#orgunitcode#"><cfdiv id="i#orgunitcode#"></td></tr>
				     
	</CFOUTPUT>

</TABLE>
 
<cfset AjaxOnLoad("doHighlight")>