<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfparam name="row" default="0">

<!--- <td bgcolor="#000080"></td> --->

<cfparam name="elementclass"   default="">
<cfparam name="colorlabel"     default="gray">
<cfparam name="fontsizelabel"  default="1">
<cfparam name="fontsize"       default="1">
<cfparam name="showcols"       default="3">

<cfif elementclass eq "Person">
	 
	    <cfquery name="Get" 
		  datasource="AppsSelection" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT   *
		  FROM     Applicant 				          
		  WHERE    PersonNo        = '#personno#'				
    	</cfquery>
		
		<cfoutput>
		  
	    <TR>		
	    <TD height="14" width="15%" class="labelit"><font face="Verdana" size="#fontsizelabel#" color="#colorlabel#">#client.IndexNoName#:</TD>
	    <TD width="20%" class="labelit"><font face="Verdana" size="#fontsize#">#get.IndexNo#</TD>
		<TD width="15%" class="labelit"><font face="Verdana" size="#fontsizelabel#" color="#colorlabel#"><cf_tl id="Gender">:</TD>
	    <TD width="20%" class="labelit"><font face="Verdana" size="#fontsize#">
				<cfif get.gender eq "M">
				   <cf_tl id="Male">
				<cfelse>
				   <cf_tl id="Female">  
				</cfif>					
			</TD>
		</TR>	
			  
	    <TR>		
	    	<TD height="14" class="labelit"><font face="Verdana" size="#fontsizelabel#" color="#colorlabel#"><cf_tl id="LastName">:</TD>
		    <TD class="labelit"><font face="Verdana" size="#fontsize#">#get.lastname# #get.lastname2#</TD>
			<TD class="labelit"><font face="Verdana" size="#fontsizelabel#" color="#colorlabel#"><cf_tl id="MaidenName">:</TD>
	    	<TD class="labelit"><font face="Verdana" size="#fontsize#">#get.MaidenName#</TD>
		</TR>		
		
	    <TR>		
	    	<TD height="14" class="labelit"><font face="Verdana" size="#fontsizelabel#" color="#colorlabel#"><cf_tl id="FirstName">:</TD>
		    <TD class="labelit"><font face="Verdana" size="#fontsize#">#get.FirstName#</TD>
		    <TD class="labelit"><font face="Verdana" size="#fontsizelabel#" color="#colorlabel#"><cf_tl id="FirstName2">:</TD>
	    	<TD class="labelit"><font face="Verdana" size="#fontsize#">#Get.MiddleName# #Get.MiddleName2#</TD>
		</TR>
		
				
	    <TR>		
	    	<TD height="14" class="labelit"><font face="Verdana" size="#fontsizelabel#" color="#colorlabel#"><cf_tl id="DOB">:</TD>
		    <TD class="labelit"><font face="Verdana" size="#fontsize#">#DateFormat(Get.DOB, CLIENT.DateFormatShow)#</TD>
			<TD class="labelit"><font face="Verdana" size="#fontsizelabel#" color="#colorlabel#"><cf_tl id="BirthCity">:</TD>
	        <TD class="labelit"><font face="Verdana" size="#fontsize#">#Get.BirthCity#</TD>
		</TR>
		
	    <TR>
		<TD height="14" class="labelit"><font face="Verdana" size="#fontsizelabel#" color="#colorlabel#"><cf_tl id="Nationality">:</TD>
	    <TD class="labelit"><font face="Verdana" size="#fontsize#">#get.Nationality#</TD>    
	    <TD class="labelit"><font face="Verdana" size="#fontsizelabel#" color="#colorlabel#"><cf_tl id="eMailAddress">:</TD>
	    <TD class="labelit"><font face="Verdana" size="#fontsize#">#get.eMailAddress#</TD>
		</TR>
		
		<TR>		
	     <td height="14" class="labelit"><font face="Verdana" size="#fontsizelabel#" color="#colorlabel#"><cf_tl id="Remarks"> :</td>
	     <TD colpsan="3" class="labelit"><font face="Verdana" size="#fontsize#">#Get.Remarks#</TD>
		</TR>
		
		</cfoutput>

</cfif>

<cfset row = 0>

<cfoutput query="getTopicList">

    <cfif topicclass eq "Person">
	
	<cfelse>
		
	   <cfset row = row + 1>
	   
	   <cfif row eq "1">	
			<tr>   
	   </cfif>  
		      	   
	   <td width="15%" height="14" class="labelit"><font face="Verdana" size="#fontsizelabel#" color="#colorlabel#">#Description#:&nbsp;</font></td>
	   <td width="15%" style="z-index:#20-currentrow#; position:relative;padding:0px" class="labelit"><font face="Verdana" size="#fontsize#">
	   	   
	   <cfif ValueClass eq "List">
	   
			    <cfquery name="GetList" 
				  datasource="AppsCaseFile" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT   T.*, 
				           P.ListCode as Selected
				  FROM     Ref_TopicList T, 
				           ElementTopic P
				  WHERE    T.Code        = '#Code#'
				  AND      P.Topic         = T.Code
				  AND      P.ListCode      = T.ListCode
				  AND      P.ElementId     = '#element#'		  
				  AND      P.ElementLineNo = '0'				
				  ORDER BY T.ListOrder
				</cfquery>
				
				<cfif GetList.ListValue neq "">
			   
				   #GetList.ListValue#
				   
				<cfelse>
				
					--
				   
				</cfif>  
			
			<cfelse>
						
				 <cfquery name="GetList" 
				  datasource="AppsCaseFile" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT  *
					  FROM    ElementTopic P
					  WHERE   P.Topic = '#GetTopicList.Code#'						 
					  AND     P.ElementId     = '#element#'		 
					  AND     P.ElementLineNo = '0'				    
				</cfquery>
				
				<cfif GetList.TopicValue neq "">
				
				   <cfif ValueClass eq "Boolean">
				   
					   <cfif GetList.TopicValue eq "1"><cf_tl id="Yes"><cfelse><cf_tl id="No"></cfif>
					   
				   <cfelseif ValueClass eq "Date">
				   
				        <cftry>
					   		#dateformat(GetList.TopicValue,CLIENT.DateFormatShow)#			
							<cfcatch></cfcatch>	   	   
						</cftry>
				   
				   <cfelse>		
				        	   
				   		#GetList.TopicValue#						
						
				   </cfif>
			   						   
				<cfelse>	
				 --
				</cfif>  					
			
			</cfif>			    
	  	   
	   </td>	
	   
	   <cfif row eq showcols>
	     <cfset row = 0>
		 </TR>
	   </cfif> 
	   
	  </cfif>  
		    
  </cfoutput>	
  