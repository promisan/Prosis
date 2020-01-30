
<!--- this is a generated document on the fly geared for word --->

<cfparam name="form.selected" default="">
<cfparam name="CLIENT.Submission" default="Manual"> 

<cfsavecontent variable="wordfile">

<cfquery name="Applicant" 
datasource="AppsSelection">
    SELECT *
    FROM   Applicant
    WHERE  PersonNo = '#url.id#'
</cfquery>

<cfquery name="Person" 
datasource="AppsEmployee">
    SELECT *
    FROM   Person
    WHERE  PersonNo = '#Applicant.employeeno#'
</cfquery>

<cfif Person.recordcount eq "0">
	
	<cfquery name="Person" 
	datasource="AppsEmployee">
	    SELECT *
	    FROM   Person
	    WHERE  IndexNo = '#Applicant.indexno#'
	</cfquery>

</cfif>

<cfquery name="Contract" 
datasource="AppsEmployee">
    SELECT   *
    FROM     PersonContract
    WHERE    PersonNo = '#person.personno#'
	ORDER BY Created DESC
</cfquery>


	<head>
	   <xml>
	        <w:WordDocument>
		<w:View>Print</w:View>
		<w:SpellingState>Clean</w:SpellingState>
		<w:GrammarState>Clean</w:GrammarState>
		<w:Compatibility>
		<w:BreakWrappedTables/>
		<w:SnapToGridInCell/>
		<w:WrapTextWithPunct/>
		<w:UseAsianBreakRules/>
		</w:Compatibility>
		<w:DoNotOptimizeForBrowser/>
		</w:WordDocument>
	   </xml>
	</head>
	
<body>
<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
  
  <TR>
  	<td width="100%"  class="regular" colspan="4" align="center"><b><font size="3" color="808080">Comparative Evaluation Report</b></td> 
  </tr>
  
  <tr><td height="3" colspan="4" ></td></tr>    
  <tr><td height="1" colspan="4" bgcolor="gray"></td></tr> 
  <tr><td height="6" colspan="4" ></td></tr>    
  
  <cfoutput>
    
  <tr>
    <td width="20%"><font face="Verdana" size="2">&nbsp;Name:</td>
    <td width="30%"><font face="Verdana" size="2">&nbsp;#Applicant.FirstName# #Applicant.LastName#</td>
    <td width="20%"><font face="Verdana" size="2">Internal:</td>
    <td width="30%"><font face="Verdana" size="2"><cfif Contract.ContractLevel neq "">YES</cfif> </td>
  </tr>
  <tr>
    <td><font face="Verdana" size="2">&nbsp;DOB:</td>
    <td><font face="Verdana" size="2">&nbsp;#DateFormat(Applicant.DOB, CLIENT.DateFormatShow)#</td>
    <td><font face="Verdana" size="2">VA:</td>
    <td><font face="Verdana" size="2"></td>
  </tr>
  <tr>
    <td><font face="Verdana" size="2">&nbsp;Nationality:</td>
    <td><font face="Verdana" size="2">&nbsp;#Applicant.Nationality#</td>
    <td><font face="Verdana" size="2">Grade/Level:</td>
    <td><font face="Verdana" size="2">#Contract.ContractLevel#</td>
  </tr>
  <tr>
    <td><font face="Verdana" size="2">&nbsp;Index No:</td>
    <td><font face="Verdana" size="2">&nbsp;#Applicant.IndexNo#</td>
    <td><font face="Verdana" size="2"></td>
    <td><font face="Verdana" size="2"></td>
  </tr>
 
  <tr><td height="3" colspan="4"></td></tr>  
  <tr><td height="1" colspan="4" bgcolor="gray"></td></tr> 
  <tr><td height="6" colspan="4"></td></tr>
    
  <cfif form.selected eq "">
  
     <TR>
       <td colspan="4" align="center">&nbsp;<font face="Verdana" size="2" color="FF0000">Sorry but you did not select any education and/or experience records</b></td>
   	</TR>
  
  	<cfabort>
  
  </cfif>
  
  </cfoutput>
    
  <TR>
    <td>&nbsp;<b><font face="Verdana" size="2">1.&nbsp;Education</b></td>   
    <td colspan="3">
	
	<cfquery name="Education" 
     datasource="AppsSelection">
       SELECT    *
       FROM      ApplicantBackground B
       WHERE     B.ExperienceCategory IN ('University','School')
		AND      B.Experienceid IN (#preservesinglequotes(Form.selected)#)
		ORDER BY ExperienceStart DESC
    </cfquery>	
	
	<cfif Education.recordcount eq "0">
	
	<font face="Verdana" color="0080FF">&nbsp;&nbsp;No items selected under this view.</font>
	
	</cfif>
	
	<table width="100%" style="border:1px solid gray">	
	<cfoutput query = "Education">
	
	 <tr>
	  <td style="padding-left:3px"><font face="Verdana" size="2">#OrganizationName#</td>
	  <td style="padding-left:3px"><font face="Verdana" size="2">#OrganizationCity# #OrganizationCountry#</td>
	  <td align="center"><font face="Verdana" size="2">#dateFormat(ExperienceStart, CLIENT.DateFormatShow)#</td>
	  <td align="center"><font face="Verdana" size="2">#dateFormat(ExperienceEnd, CLIENT.DateFormatShow)#</td>	  
  	 </tr>
	 
	  <cfquery name="Structured" 
       datasource="AppsSelection">
        SELECT   B.ExperienceClass, B.Description
        FROM     ApplicantBackgroundField A, Ref_Experience B
        WHERE    A.ExperienceId = '#ExperienceId#'
	    AND      A.ExperienceFieldId = B.ExperienceFieldId
      </cfquery>	
	  
	 <cfif structured.recordcount gt 0>  
	 
	 <tr><td></td><td colspan="3" style="padding:2px">	 	  	
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">	  
   	  <cfloop query = Structured>
	  <tr bgcolor="f1f1f1">
   		<td width="33%"style="padding:2px"  align="left"><font face="Verdana" size="1">#Structured.Description#</td>
	  </tr>	
      </cfloop>			   
	  </table>
	  </td>
	 
	 </tr>
	 
	</cfif>	
	
	</cfoutput>
	</table>
	
	</td></tr>
	
	<tr><td height="3" colspan="4"></td></tr>  
	<tr><td height="1" colspan="4" bgcolor="gray"></td></tr> 
	<tr><td height="6" colspan="4"></td></tr> 
			
	<TR>
    <td colspan="1">&nbsp;<b><font face="Verdana" size="2">2.&nbsp;Employment</b></td>
   	<td colspan="3">
		
	<cfquery name="Work" 
     datasource="AppsSelection">
       SELECT   *
       FROM     ApplicantBackground B
       WHERE    B.ExperienceCategory = 'Employment'
		 AND    B.Experienceid IN (#preservesinglequotes(Form.selected)#)
		ORDER BY ExperienceStart DESC
    </cfquery>	
		
	<cfset durT = 0>
	
	<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#BackgroundCount">
	
	<cfquery name="Table" 
     datasource="AppsQuery">
		CREATE TABLE dbo.[tmp#SESSION.acc#BackgroundCount] (
		[MonthNo] [int] NOT NULL 
		) ON [PRIMARY]
    </cfquery>	
	
	<table width="100%" style="border:1px solid gray">	
	
	<cfoutput query = "Work">
	
	 <tr>
	  <td style="padding-left:3px"><font face="Verdana" size="2">#OrganizationName#</td>
	  <td style="padding-left:3px"><font face="Verdana" size="2">#OrganizationCountry#</td>  
	  <td width="50">
	  	  
	  <!---
	      <cfquery name="Structured" 
	       datasource="AppsSelection" 
	       username="#SESSION.login#" 
	       password="#SESSION.dbpw#">
	       SELECT B.ExperienceClass, B.Description
	        FROM   ApplicantBackgroundField A, Ref_Experience B
	        WHERE  A.ExperienceId IN (#preservesinglequotes(Form.selected)#)
		    AND    A.ExperienceFieldId = B.ExperienceFieldId
		  </cfquery>	 
			
	   	  <cfif structured.recordcount gt 0>
	   	  
		   	  <cfloop query = "Structured">
			    <font size="2">#Structured.Description#<br>
		      </cfloop>		
		  
		  </cfif>	
		  --->  
			  
 	  </td>
	  	  	  
	  <td style="padding-left:3px"><font face="Verdana" size="2">#ExperienceDescription#</td>
      <td style="padding-left:3px" align="center"><font face="Verdana" size="2">#dateFormat(ExperienceStart, CLIENT.DateFormatShow)#</td>
	  <td style="padding-left:3px" align="center"><font face="Verdana" size="2">#dateFormat(ExperienceEnd, CLIENT.DateFormatShow)#</td>
	  
	  <cfif ExperienceEnd eq "">
	      <cfset End = now()>
	  <cfelse>
	    <cfset End = ExperienceEnd>
	  </cfif>
	 	 
	  <cfif ExperienceStart neq "" and End gt ExperienceStart>

		  <cfset dayDiff = Day(end)-Day(ExperienceStart)>
		  <cfif dayDiff gte 20>
		   	<cfset MonthPart = 1>
		  <cfelse>
		 	<cfset MonthPart = 0>		  		
		  </cfif>
		  
	      <cfset st = year(ExperienceStart)*12>
		  <cfset st = st+month(ExperienceStart)>
		  <cfset ed = year(End)*12>
		  <cfset ed = ed+month(End)>
		  <cfset dur = (#ed#-#st#+#MonthPart#)>
		  
		  <cfset Span = (st+dur-1)>
		 
		   <cfloop index="m" from="#st#" to="#span#">			 		  
			  <cfquery name="Insert" 
		       datasource="AppsQuery" 
		       username="#SESSION.login#" 
		       password="#SESSION.dbpw#">
		       INSERT INTO tmp#SESSION.acc#BackgroundCount
			   (MonthNo)
			   VALUES (#m#)  
		   </cfquery>	 
			 		     
		  </cfloop>
		  
	  <cfelse>	 
    	  <cfset dur = 0> 
	  </cfif>	  
	   <td valign="top" align="right"><font size="2">
	    <cfif #dur# neq "0">   
	   #numberFormat(dur,"__")# mth</cfif></td>
	 </tr>
	
	</cfoutput>
	
	<cfquery name="Total" 
		datasource="AppsQuery">
		  SELECT count(Distinct MonthNo) as Total 
		  FROM tmp#SESSION.acc#BackgroundCount 
	</cfquery>	 
	
	<tr><td colspan="6" align="right" bgcolor="f4f4f4" style="border:1px solid gray"><font>Total relevant work history: &nbsp;</td>
	<td align="right" bgcolor="e4e4e4"><cfoutput><font size="4" face="Verdana" color="0080FF">
	
	<cfif #Total.total# gte "12">
	    <cfset sy = #int(total.total/12)#>
		
		#sy#&nbsp;yr<cfif #sy# gt "1">s</cfif>
		<cfset sm = #total.total#-(sy*12)>
		 <cfif #sm# neq "0">
			&nbsp;#sm#&nbsp;mth<cfif #sm# gt "1">s</cfif>
		</cfif>
	<cfelse>
	    <cfif total.total neq "0"><font size="2" color="0080FF">#total.total# mths</cfif>
	</cfif>
	
	</cfoutput>
	
	</b></td></tr>
	</table>
	
	</td></tr>
	
	<tr><td height="6" colspan="4"></td></tr>  
	<tr><td height="1" colspan="4" bgcolor="gray"></td></tr> 
	<tr><td height="10" colspan="4"></td></tr>
	      
	<cfquery name="Language" 
	datasource="AppsSelection">
	SELECT   L.*, 
	         R.LanguageClass, 
		     R.ListingOrder, 
		     R.LanguageName, 
			 S.Source
			
	FROM     ApplicantSubmission S, ApplicantLanguage L, Ref_Language R
	WHERE    S.PersonNo = '#URL.ID#'
	  AND    S.ApplicantNo = L.ApplicantNo	 
	  AND    L.LanguageId = R.LanguageId	
	  AND    S.Source = '#url.source#'  
	ORDER BY LanguageClass, ListingOrder, LanguageName
	</cfquery>
	
	<TR>
    <td>&nbsp;<b><font face="Verdana" size="2">3.&nbsp;Languages</b></td>
 	
	<td colspan="3">
	
	<table width="100%" style="border:1px solid gray">
			
		<TR>
		    <td width="20%" align="left">&nbsp;<font face="Verdana" size="2">Language</td>
		    <TD width="8%"  align="center"><font face="Verdana" size="2">Prof.</TD>
		    <TD width="8%"  align="center"><font face="Verdana" size="2">Mother T.</TD>
			<TD width="8%"  align="center"><font face="Verdana" size="2">Read</TD>
			<TD width="8%"  align="center"><font face="Verdana" size="2">Write</TD>
			<TD width="8%"  align="center"><font face="Verdana" size="2">Speak</TD>
			<TD width="8%"  align="center"><font face="Verdana" size="2">Understand</TD>
		    <TD width="8%"  align="center"><font face="Verdana" size="2">Clearance</TD>						
		</TR>	
	
		<cfoutput query="Language" group="LanguageName">
		
		<TR>
		<TD>&nbsp;<font face="Verdana" size="2">#LanguageName#</TD>
		<td align="center"><cfif Proficiency eq "1"><font face="Verdana" size="2">Yes</cfif></td>
		<TD align="center"><cfif MotherTongue eq "1"><font face="Verdana" size="2">Yes</cfif></TD>
		<TD align="center">
		<font face="Verdana" size="2">
		<cfswitch expression="#LevelRead#">
			<cfcase value="1">High</cfcase>
			<cfcase value="2">Medium</cfcase>
			<cfcase value="3">Low</cfcase>
			<cfcase value="9">N/A</cfcase>
		</cfswitch>
		</TD>
		<TD align="center">
		<font face="Verdana" size="2">
		<cfswitch expression="#LevelWrite#">
			<cfcase value="1">High</cfcase>
			<cfcase value="2">Medium</cfcase>
			<cfcase value="3">Low</cfcase>
			<cfcase value="9">N/A</cfcase>
		</cfswitch>
		</TD>
		<TD align="center">
		<font face="Verdana" size="2">
		<cfswitch expression="#LevelSpeak#">
			<cfcase value="1">High</cfcase>
			<cfcase value="2">Medium</cfcase>
			<cfcase value="3">Low</cfcase>
			<cfcase value="9">N/A</cfcase>
		</cfswitch></TD>
		<TD align="center">
		<font face="Verdana" size="2">
		<cfswitch expression="#LevelUnderstand#">
			<cfcase value="1">High</cfcase>
			<cfcase value="2">Medium</cfcase>
			<cfcase value="3">Low</cfcase>
			<cfcase value="9">N/A</cfcase>
		</cfswitch>
		</TD>
		<td align="center">
		<font face="Verdana" size="2">
		<cfif Status is "0">Pending</cfif>
		<cfif Status is "1">Cleared</cfif>
		<cfif Status is "9">Cancelled</cfif>
		</td>		
				
		</TR>
				
		</cfoutput>
	
	
	</table>
	
	</td></tr>

  <tr><td height="6" colspan="4"></td></tr>  
  <tr><td height="1" colspan="4" bgcolor="gray"></td></tr> 
  <tr><td height="10" colspan="4"></td></tr>  
  
  <TR>
    <td colspan="2">&nbsp;<b><font face="Verdana" size="2">4. Professionalism/Gender</b></td>
	<td align="right" colspan="2" bgcolor="f4f4f4" style="padding-right:2px"><font face="Verdana" size="1">1=Outstanding 2=Satisfactory 3=Partially Satisfactory 4=Unsatisfactory&nbsp;</td>
  </TR>
  
  <tr><td></td><td height="10" colspan="3">
  
  <table width="100%">
	
		<TR>
		    <td height="25" width="20%" align="left"></td>
		    <TD width="50%">&nbsp;<font face="Verdana" size="2">Competency</TD>
		    <TD width="10%" align="center">&nbsp;<font face="Verdana" size="2">Score</TD>
			<TD width="20%" align="center">&nbsp;<font face="Verdana" size="2">Updated</TD>						
		</TR>	
   		
									
		<TR>
			<TD height="30"><font face="Verdana"></TD>
		    <TD><font face="Verdana"></TD>
			<TD align="center"></TD>
			<TD align="center"></TD>				
		</TR>
			
		<tr><td colspan="4" height="60" bgcolor="f4f4f4" style="border:1px solid gray"></td></tr>
		  
    </table>
	
	</td>
  </tr>	
  
  <TR>
    <td colspan="2">&nbsp;<b><font face="Verdana" size="2">5. Competencies</b></td>
	<td align="right" colspan="2" bgcolor="f4f4f4" style="padding-right:2px"><font face="Verdana" size="1">1=Outstanding 2=Satisfactory 3=Partially Satisfactory 4=Unsatisfactory&nbsp;</td>
  </TR>
	   
  <tr><td></td><td height="10" colspan="3">
	  
	<cfquery name="Competence" 
	datasource="AppsSelection">
		SELECT  A.CompetenceScore, A.Created as LastUpdated, R.*
		FROM    ApplicantSubmission S, 
		        ApplicantCompetence A, 
				Ref_Competence R, 
				Ref_CompetenceCategory C
		WHERE   A.CompetenceId = R.CompetenceId
		 AND    S.ApplicantNo = A.ApplicantNo
		 AND    S.PersonNo = '#URL.ID#'
		 AND    R.CompetenceCategory = C.Code	
    	 AND    C.Operational = 1
	     AND    R.Operational = 1
		 AND    S.Source = '#url.source#'  		
		 ORDER BY CompetenceCategory, ListingOrder
	</cfquery>
	
	<table width="100%">
	
		<TR>
		    <td width="20%" align="left">&nbsp;&nbsp;&nbsp;<font face="Verdana" size="2">Class</td>
		    <TD width="50%">&nbsp;<font face="Verdana" size="2">Competency</TD>
		    <TD width="10%" align="center">&nbsp;<font face="Verdana" size="2">Score</TD>
			<TD width="20%" align="center">&nbsp;<font face="Verdana" size="2">Updated</TD>						
		</TR>	
  
  		<cfoutput query="Competence">
									
			<TR>
				<TD height="30"><font face="Verdana" size="2">&nbsp;&nbsp;&nbsp;#CompetenceCategory#</TD>
			    <TD><font face="Verdana" size="2">&nbsp;#Description#</TD>
				<TD align="center"><font face="Verdana" size="2">&nbsp;#CompetenceScore#</TD>
				<TD align="center"><font face="Verdana" size="2">#DateFormat(LastUpdated,CLIENT.DateFormatShow)#</TD>				
			</TR>
			
			<tr><td colspan="4" height="60" bgcolor="f4f4f4" style="border:1px solid gray"></td></tr>
			
		</CFOUTPUT>
  
    </table>
   
  </td></tr>	
  
  <TR>
    <td colspan="1">&nbsp;<b><font face="Verdana" size="2">Overall Evaluation</b></td>
	<td colspan="3" height="60" bgcolor="f4f4f4" style="border:1px solid gray"></td>
  </TR>

  <!---
  <tr>
      <td colspan="4" align="center">Prepared by <cfoutput>#SESSION.first# #SESSION.last# (time stamp: #DateFormat(now(), CLIENT.DateFormatShow)# #TimeFormat(now(), "HH:MM")#)</cfoutput></b></td>
  </tr>
  --->  
  
  <!---
  <script>
	  window.print()
  </script>
  --->
     
</table> 

</cfsavecontent>

	<cfoutput>
	<cf_AssignId>
	<cfset eId = rowguid>
		
	<cfset filedir = "#SESSION.rootPath#\CFRStage\user\#SESSION.acc#\">
	<cfset vFilename = "doc_#eId#.doc">
	<cfset fullname = filedir & vFilename>

	<cffile action="write" file="#fullname#" output="#wordfile#"> 
	<table width="100%">
	<tr height="60">
		<td></td>
	</tr>
	<tr>
		<td align="center">
			<table style="border:1px dotted silver" width="290">
			<tr><td>
			<a href="javascript:fileOpen('#Client.root#/CFRStage/user/#Session.acc#/#vFilename#')">
		    <img src="#client.root#/images/word-icon.png">
			</a>
			</td>
			<td class="labellarge">
			<b>
			<a href="javascript:fileOpen('#Client.root#/CFRStage/user/#Session.acc#/#vFilename#')">
			<font color="6688aa">Open Comparative <br>Evaluation Document</font></a>
			</font>
			</td>
		</td>	
	</tr>
	</table>
	</cfoutput>