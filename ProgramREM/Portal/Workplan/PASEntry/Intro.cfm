<!--
    Copyright © 2025 Promisan B.V.

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
<cf_screentop html="No" jquery="Yes" scroll="no">

<cfquery name="Section" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ContractSection
	WHERE Code = '#URL.Section#'
</cfquery>
    <style>
        .SplashTitleLogo{width: 320px;height: auto;}
        strong{font-weight: 600;}
    
     .SplashWindow{
    width: 99%;height:auto;margin:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif,'Raleway',sans-serif';'}
    .SplashWindowLeft{width: 1%;float:left;background: #f1f1f1;height:96%;padding:4% 2% 2%;font-size:12px;color: #555555;}
    
    .SplashEditButton{background: #cccccc; padding: 1px 0 3px; border-radius: 10px;display:block;cursor: pointer;width: 100px;margin-top: 10px;}
    .SplashEditButton:hover{
        background: #ffffff;        
    }
    
    .SplashWindowRight{width:96%;float:right;height:15%;}
    .SplashWindowRight h1{font-size: 32px;margin: 0;}
    .SplashWindowRight h2{font-size: 16px;margin: 0;}
    .SplashWindowRight h4{font-weight:normal;font-size:14px;margin:-3px 0 1px;color:#333333;}

    .SplashWindowRight p{font-size: 15px;margin: 0;}
    .SplashTitleLogo{width: 320px;height: auto;}
    
    h1,h2,h3,h4{font-weight: 200;}
    p{
        font-size: 13px!important;
    }
    
    .SplashWindowLeft h2{font-size: 24px;color: #333333;}
    .SplashWindowLeft h3{font-size: 18px;font-weight:normal;color: #333333;margin: 0;}
    .SplashWindowLeft a{text-decoration: none;color: #333333;}
    .SplashWindowLeft a:hover, .SplashWindowLeft strong:hover{color: #C83702;}
    .SplashWindowLeft strong{color:#1F5582}
    
    
    .SplashButtonItem{float: left;width: 40%; max-width:240px; min-width:250px; height:auto; min-height: 58px; max-height: 100px;background: #FFFFFF; padding: 6px; cursor: pointer;margin:0 2% 2% 0; }
    .SplashButtonItem.SmallButton{ min-height: 20px; max-height: 40px;width:20%;min-width: 210px; padding: 2px;}
    .SplashButtonItem.SmallButton h2{font-size: 15px;padding: 2px 0 0 5px; }

    .SplashButtonItemTop{height: 20px;}
    .SplashButtonItemTopLeft{height:auto;float: left;width: 40px;margin: 0 0 0 6px;border-right: 1px solid #cccccc;}
    .SplashButtonItemTopLeft img{width: 50px;height: auto;float:left;height:auto;outline: 1px solid transparent;}
    .SplashButtonItem.SmallButton .SplashButtonItemTopLeft img{width: 40px;height: auto;float:left;height:auto;outline: 1px solid transparent;}
    .SplashButtonItemTopRight{height:auto;float: left;width: auto;  display: inline-block;vertical-align: middle;margin-top: 1px;}
    .SplashButtonItemTopRight h2{font-weight: 200;font-size:16px;line-height: 20px;margin: 0 0 0 8px;}
    .SplashButtonItemBottom{width: 100%;clear: both;padding-top: 4px;}
    
    
    .SplashButtonItemBottom p{padding:0 3%;margin-bottom: 10px;}
    .SplashButtonRowWindow{
        width:100%;clear: both;
    }
        
        .stpno {
    font-size: 35px;
    color: #BF301D;
    margin: 0 0 0 4px;
    padding: 0;
    line-height: 25px;
}
    .StepNext{
    background: url('<cfoutput>#session.root#/Images/Logos/PAS/StepNext.png</cfoutput>') no-repeat;
    background-size: 270px 58px;
    width: 100px;
    background-position-x: right;
    margin:0 10px 5px 0;
}
    .StepEnd{
    background: url('<cfoutput>#session.root#/Images/Logos/PAS/StepEnd.png</cfoutput>') no-repeat;
    background-size: 270px 58px;
    background-position-x: right;
        }
        
    .TTLCycles{
        font-size: 20px!important;
        font-weight: 400;
        padding: 12px 0 12px;
        clear: both;
        }
        
    @media only screen and (max-width: 900px) {
    .SplashWindowLeft{
        display: none;
        }
    }
    @media only screen and (max-width: 1000px) {
        .SplashButtonItemTopRight h2{font-size:16px;line-height: 20px;}
        .SplashButtonItemBottom p{font-size: 12px!important;margin-bottom: 10px;}
    }
    </style>
<cfoutput>

<table width="100%" height="100%" bgcolor="ffffff" border="0" cellspacing="0" cellpadding="0">

<tr><td valign="top" style="padding:20px 0;height:97%">

	<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">
		
	<tr>
	
	<td>
	
		<div class="SplashWindow">
		    <div class="SplashWindowRight">
		       
		       <div style="width: 100%;">
		           <div class="emptyspace" style="height: 10px;"></div>
		           <h2 style="font-weight: 200;font-size: 24px;">Human Resources <br><strong>Performance Appraisal Report</strong></h2>
		        
		        </div> 
		        <div class="emptyspace" style="height: 20px;"></div>
		        <p style="font-size: 16px!important;max-width:678px;clear: both">The STL Performance Appraisal cycle has the following stages:</p>
		        <div class="emptyspace" style="height: 10px;"></div>
		        <h2 class="TTLCycles">1. Start Of Cycle</h2>
		        <div class="SplashButtonRowWindow">
		            <div class="SplashButtonItem StepNext" style="min-width: 200px;">
		                <div class="SplashButtonItemTop"  style="min-width: 200px;">
		                    <div class="SplashButtonItemTopRight ">
		                    <h2><strong>Review</strong><br> your Personal Data</h2>
		                    </div>                    
		                </div>
		            </div>
		           <div class="SplashButtonItem StepNext" style="min-width: 180px;">
		                <div class="SplashButtonItemTop"  style="min-width: 180px;">
		                    <div class="SplashButtonItemTopRight">
		                    <h2><strong>Prepare</strong><br> your workplan</h2>
		                    </div>                    
		                </div>
		            </div>
		            <div class="SplashButtonItem StepNext" style="min-width: 180px;">
		                <div class="SplashButtonItemTop"  style="min-width: 180px;">
		                    <div class="SplashButtonItemTopRight">
		                    <h2><strong>Submit</strong><br> your workplan</h2>
		                    </div>                    
		                </div>
		            </div>
		            </div>
		        <h2 class="TTLCycles">2. Midterm Review</h2>
		            <div class="SplashButtonRowWindow">
		            <div class="SplashButtonItem StepNext" style="min-width: 160px;">
		                <div class="SplashButtonItemTop"  style="min-width: 160px;">
		                    <div class="SplashButtonItemTopRight">
		                    <h2>Midpoint<br><strong>Review</strong></h2>
		                    </div>                    
		                </div>
		            </div>
		        </div>
		        <h2 class="TTLCycles">3. Full Performance Appraisal</h2>
		        <div class="SplashButtonRowWindow">
		            <div class="SplashButtonItem StepNext" style="min-width: 160px;">
		                <div class="SplashButtonItemTop"  style="min-width: 160px;">
		                    <div class="SplashButtonItemTopRight">
		                    <h2><strong>Self</strong><br> Evaluation</h2>
		                    </div>                    
		                </div>
		            </div>
		          <div class="SplashButtonItem StepNext" style="min-width: 160px;">
		                <div class="SplashButtonItemTop"  style="min-width: 160px;">
		                    <div class="SplashButtonItemTopRight">
		                    <h2><strong>FRO</strong><br> Evaluation</h2>
		                    </div>                    
		                </div>
		            </div>
		            <div class="SplashButtonItem StepNext" style="min-width: 200px;">
		                <div class="SplashButtonItemTop"  style="min-width: 200px;">
		                    <div class="SplashButtonItemTopRight">
		                    <h2><strong>SRO</strong><br> Recommendations</h2>
		                    </div>                    
		                </div>
		            </div>
		            <div class="SplashButtonItem StepNext" style="min-width: 210px;">
		                <div class="SplashButtonItemTop"  style="min-width: 210px;">
		                    <div class="SplashButtonItemTopRight">
		                     
		                        <h2><span style="">Staffmember</span><br><strong> Acknowledgement</strong></h2>
		                    </div>                    
		                </div>
		            </div>
		        </div>
		        <div class="SplashButtonRowWindow">
		          <h3 style="font-size: 18px;padding: 20px 0 0; margin-bottom: 10px!important;">For more information on how to use the PAR Portal please download the</h3>
                    <a style="font-size: 20px;" href="http://stloffice.stl/sites/doa/stltraining/Shared%20Documents/Forms/AllItems.aspx" target="_new"><img width="36" height="36"  style="vertical-align:middle" src='<cfoutput>#session.root#/Images/PDF-Download.png</cfoutput>'> Instruction manual</a>
		        </div>
		    </div>
		</div>
		
	</td>	

    </tr> 	

	</table>
	
</td></tr>

<tr><td valign="bottom" style="padding-bottom:10px">

     <cf_Navigation	    
		 Alias         = "AppsEPAS"
		 TableName     = "Contract"
		 Object        = "Contract"
		 ObjectId      = "Id"		 
		 Section       = "#URL.Section#"
		 Id            = "#URL.ContractId#"
		 ButtonWidth   = "250"
		 BackEnable    = "0"
		 HomeEnable    = "0"
		 ResetEnable   = "0"
		 ResetDelete   = "0"	 
		 ProcessEnable = "0"
		 NextEnable    = "1"
		 NextName      = "Continue"
		 NextMode      = "1"
		 IconWidth 	   = "48"
		 IconHeight	   = "48">		 

</td></tr>
		  
</table>

</cfoutput>