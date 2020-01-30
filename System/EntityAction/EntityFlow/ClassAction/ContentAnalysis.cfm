<style type="text/css">
	td.gtext_small{
		font-family:"Verdana",Times,serif;
		font-size : 7pt;
	}
		
</style>

<cfset URL.DataSource= #Replace(URL.Datasource,"|","\")#>

<cfif URL.PublishNo neq "">

<cfif not directoryExists("#SESSION.rootdocumentpath#\_readfile\#SESSION.acc#")>

	<cfdirectory action="CREATE"
	    directory="#SESSION.rootdocumentpath#\_readfile\#SESSION.acc#">
		
</cfif>
	

<cfset vSQLCONTENT="">
	
<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
<tr bgcolor="#C4C6E0">
	<td height="24" align="center" colspan="6">
	<b>Content Analysis</b> 
	<br>
	<cfoutput>
	<img src="#SESSION.root#/images/read.gif">
	<a href="#SESSION.root#/CFRStage/User/#SESSION.acc#/#URL.EntityCode#-#Replace(URL.EntityClass,"/","-","all")#-#URL.PublishNo#.txt" target="_new">
	Generated Script
	</a>
	</cfoutput>
	</td>
</tr>

<tr><td height="1" bgcolor="C0C0C0" colspan="6"></td></tr>
<tr>
	<td colspan="6">
		<table width="100%" class="regular">
			<tr>
				 <td class="regular" width="2%">
					&nbsp;
				 </td>								
				 <td class="regular" width="15%">
				   <b>Record</b>
				 </td>
				 <td class="regular" width="20%">
				   <b>Condition</b>
				 </td>	 
				 <td class="regular" width="10%">
				   <b>Operation</b>
				 </td>				 
				 <td class="regular" width="26%">
				   <b>Master</b>
				 </td>
				 <td class="regular" width="26%">
				   <b>Destination</b>
				 </td>
			</tr>		
		</table>
	</td>
</tr>						
<cfoutput>

<cfset oComparison = CreateObject("component","Service.EntityAction.WkfComparison.Comparison")/>



<cfquery name="first" datasource="AppsOrganization">
		SELECT 
		Distinct Len(Table_Name),Table_Name as TableName
		FROM
		INFORMATION_SCHEMA.COLUMNS 
		WHERE Table_Name like 'Ref_Entity%'
		<cfif URL.PublishNo eq 0>
			AND Table_Name not like '%Publish%'
		</cfif>
		ORDER BY Len(Table_Name)
</cfquery>



<cfloop query="first">

	
		<!---
		
		Building the primary key , in the future refer to data control 
		Control.dbo.DictionaryTableField
		
		---->
		<cfquery name="qPK" datasource="AppsOrganization">
			SELECT Distinct column_name as 'Field' 
			FROM information_schema.table_constraints pk 
				INNER JOIN information_schema.key_column_usage c on c.table_name = pk.table_name 
					AND c.constraint_name = pk.constraint_name
			WHERE constraint_type in ('primary key','foreign key')
			AND pk.table_name='#First.TableName#'		
		</cfquery>		


		<cfinclude template="BuildPrimaryKey.cfm">
		

		
		<cfif PK neq "">
			<cftry>
			<cfquery name="GetMain" datasource="AppsOrganization">
				SELECT *
				FROM #First.TableName#
				WHERE #PreserveSingleQuotes(PK)#
			</cfquery>		
			<cfcatch>
			<cfquery name="GetMain" datasource="AppsOrganization">
				SELECT *
				FROM #First.TableName#
				WHERE 1=0
			</cfquery>		
			</cfcatch>
			</cftry>	

		<cfelse>
			<!--- Error of key that has not been found ---->
			
			
			<cfquery name="GetRel" datasource="AppsOrganization">
				SELECT  
					OBJECT_NAME(f.parent_object_id) AS TableName, 
					COL_NAME(fc.parent_object_id,  
					fc.parent_column_id) AS ColumnName, 
					OBJECT_NAME (f.referenced_object_id) AS ReferenceTableName, 
					COL_NAME(fc.referenced_object_id,  
					fc.referenced_column_id) AS ReferenceColumnName 
				FROM sys.foreign_keys AS f 
					LEFT JOIN sys.foreign_key_columns AS fc 
					ON f.OBJECT_ID = fc.constraint_object_id 
					WHERE  
					OBJECT_NAME(f.parent_object_id) ='#First.TableName#'
					AND OBJECT_NAME (f.referenced_object_id) like 'Ref_Entity%'
			</cfquery>
			


			

			<cfset PK3="">			
			<cfloop query="GetRel">
			
					<cfquery name="qPK" datasource="AppsOrganization">
						SELECT column_name as 'Field' 
						FROM information_schema.table_constraints pk 
							INNER JOIN information_schema.key_column_usage c on c.table_name = pk.table_name 
								AND c.constraint_name = pk.constraint_name
						WHERE constraint_type in ('primary key')
						AND pk.table_name='#GetRel.ReferenceTableName#'		
					</cfquery>		
			
			
					<cfinclude template="BuildPrimaryKey.cfm">

					<cfif PK eq "">
						<!--- Last resort --->
						<cfset PK="EntityCode='#URL.EntityCode#'">
					</cfif>			
			
					<cfif PK3 eq "">
						<cfset PK3 = "#GetRel.ColumnName# in (SELECT #GetRel.ReferenceColumnName# FROM #GetRel.ReferenceTableName# WHERE #PK#)">
					<cfelse>
						<cfset PK3 = "#PK3# OR #GetRel.ColumnName# in (SELECT #GetRel.ReferenceColumnName# FROM #GetRel.ReferenceTableName# WHERE #PK#)">
					</cfif>
			</cfloop>
			
			<cfif PK3 eq "">
				<!--- Last resort --->
				<cfset PK3="EntityCode='#URL.EntityCode#'">
			</cfif>
			
			<cfquery name="GetMain" datasource="AppsOrganization">
				SELECT *
				FROM #First.TableName#
				WHERE #PreserveSingleQuotes(PK3)#
			</cfquery>	
		

		</cfif>

		
		
		<cfquery name="qPK2" datasource="AppsOrganization">
			SELECT column_name as 'Field' 
			FROM information_schema.table_constraints pk 
				INNER JOIN information_schema.key_column_usage c on c.table_name = pk.table_name 
					AND c.constraint_name = pk.constraint_name
			WHERE constraint_type in ('primary key')
			AND pk.table_name='#First.TableName#'		
		</cfquery>				
		
		
		<cfset foundOne=0>
		
		<cfloop query="GetMain">
		
				<cfset PK2="">
			    <cfloop query="qPK2">
					<cfset vMainValue = Evaluate("GetMain.#qPK2.Field#")>
					<cfif PK2 eq "">
						<cfset PK2="#qPK2.Field#='#vMainValue#'">
					<cfelse>
						<cfset PK2="#PK2# AND #qPK2.Field#='#vMainValue#'">							
					</cfif>
				</cfloop>


				
				<cfset aResponse = oComparison
							.Values("#URL.DataSource#","#First.TableName#","#PK2#")/>
				
				<cfloop index="x" from="1" to="#ArrayLen(aResponse)#">
				
					<cfif foundOne eq 0>
						<tr bgcolor="##F8C0BD" onclick="javascript:expand('#First.TableName#')" style="cursor: pointer;" >
							<td colspan="6" align"center" height="15" valign="center"><img src="#SESSION.root#/images/alert.gif">&nbsp;&nbsp;#First.TableName#</td>
						</tr>
						<tr id="#First.TableName#" class="hide">
						<td colspan="6">
							<table width="100%" class="regular">
								<cfset foundOne=1>
					</cfif>
						 		 <tr>
									 <td width="2%"><img src="#SESSION.root#/images/join.gif"></td>
							 		 <td width="15%" class="gtext_small">
									   #aResponse[x].Field#
									 </td>
							 		 <td width="20%" class="gtext_small">
									   <cfset Condition=#REReplace(aResponse[x].PK,"EntityCode='[A-Za-z0-9_]*'","","ALL")#>
									   <cfset Condition=#REReplace(Condition,"EntityClass='[A-Za-z0-9_]*'","","ALL")#>									   
									   <cfset Condition=#REReplace(Condition,"ActionPublishNo='[A-Za-z0-9_]*'","","ALL")#>									   									   
									   <cfset Condition=#REReplace(Condition,"PublishNo='[A-Za-z0-9_]*'","","ALL")#>									   									   
									   <cfset Condition=#Replace(Condition," AND","","ALL")#>									   									   									   
									   #Condition#
									 </td>						 
							 		 <td width="10%" class="gtext_small">
									   #aResponse[x].Type#
									 </td>									 
							 		 <td width="26%" class="gtext_small">
									   #aResponse[x].Source#
									 </td>
							 		 <td width="26%" class="gtext_small">
									   #aResponse[x].Destination#
									 </td>
								 </tr>

								 <cfset vSQLCONTENT=vSQLCONTENT  & CHR(13) & #aResponse[x].SQL#>
								 
			    </cfloop>		
		</cfloop>
		<cfif foundOne eq 0>
			<tr bgcolor="##EAFAF6">
				<td colspan="6" align"center">&nbsp;&nbsp;#First.TableName#</td>
			</tr>
		<cfelse>
			</table>
			</td>
			</tr>
		</cfif>		

</cfloop>


 <cffile action="WRITE" 
     file="#SESSION.rootdocumentpath#\_readfile\#SESSION.acc#\#URL.EntityCode#-#Replace(URL.EntityClass,"/","-","all")#-#URL.PublishNo#.txt" 
     output="#vSQLCONTENT#" 
     addnewline="Yes" 
     fixnewline="No"> 					   
	 
<cffile action="COPY" 
source="#SESSION.rootdocumentpath#\_readfile\#SESSION.acc#\#URL.EntityCode#-#Replace(URL.EntityClass,"/","-","all")#-#URL.PublishNo#.txt" 
destination="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#URL.EntityCode#-#Replace(URL.EntityClass,"/","-","all")#-#URL.PublishNo#.txt">		 
	 

</cfoutput>



</table>
</cfif>