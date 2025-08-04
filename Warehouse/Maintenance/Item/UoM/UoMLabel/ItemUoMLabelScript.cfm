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
<cf_PrinterQZTray jquery="No">

<cf_tl id="You will print many labels.\nDo you want to continue?\n\nLabels to print:" var="confirmPrintManyLabels">

<cfoutput>

    <script language="JavaScript">

        function printEPL(barcode,itemno,uom,desc) {

            var config = qz.configs.create("ProsisPrinter");

            total=$('##labels').val();

            var aStr = desc.split("|");

            //BX,Y,Rotation,CodeType,Narrow,WideBar,Height,PrintHumanReadable (B=Yes,N=No), data.
            //122
            var x = 0;
            var y = 80;
            var str =""; 
                
            for (i = 0; i < aStr.length; i++) {
                str = str+'A'+x+','+y+',0,3,1,1,N,"'+aStr[i]+'"\n';
                y = y + 20;
            }                                                             

            //'B'+x+',10,0,9,3,2,80,B,"'+barcode+'"\n', -- COD93
            //'B'+x+',10,0,E30,3,N,80,B,"'+barcode+'"\n', -- EAN13
            //https://www.servopack.de/support/zebra/EPL2_Manual.pdf

            data = [
                '\nN\n',
                'q350\n', //  q=width in dots - check printer dpi
                'Q88,26\n', // Q=height in dots - check printer dpi
                'B0,26,0,E30,3,7,50,B,"'+barcode+'"\n',
                str,
                '\nP1,1\n'
            ];

            qz.print(config, data).catch(function(e) { console.error(e); });

        }

        function printLabelEPL(barcode,itemno,uom,printobject,countlabels,printbarcode) {

            if (countlabels >= 5) {
                if (confirm('#confirmPrintManyLabels# : ' + countlabels)) {
                    doPrintLabelEPL(barcode,itemno,uom,printobject,countlabels,printbarcode);
                }
            } else {
                doPrintLabelEPL(barcode,itemno,uom,printobject,countlabels,printbarcode);
            }

        }

        function doPrintLabelEPL(barcode,itemno,uom,printobject,countlabels,printbarcode) {

            var config = qz.configs.create("ProsisPrinter");

            var x = 0;
            var y = 0;
            var str = ""; 
            var vCode = "";
                
            for (i = 0; i < printobject.length; i++) {
                if (printobject[i].NAME == 'code') {
                    vCode = printobject[i].TEXT;
                }

                if (printobject[i].PRINT) {
                    str = str+'A'+x+','+y+',0,'+printobject[i].SIZE+',1,'+printobject[i].TEXTHEIGHT+',N,"'+printobject[i].TEXT+'"\n';
                    y = y + printobject[i].HEIGHT;
                }
            }                                 

            //BX,Y,Rotation,CodeType,Narrow,WideBar,Height,PrintHumanReadable (B=Yes,N=No), data.
            //'B'+x+',10,0,9,3,2,80,B,"'+barcode+'"\n', -- COD93
            //'B'+x+',10,0,E30,3,N,80,B,"'+barcode+'"\n', -- EAN13
            //'B0,0,0,E30,3,7,150,N,"'+barcode+'"\n', --ORIGINAL
            //https://www.servopack.de/support/zebra/EPL2_Manual.pdf
            //B0,26,0,E30,3,7,50,B

            data1 = [
                '\nN\n',
                'q350\n', //  q=width in dots - check printer dpi
                'Q90\n', // Q=height in dots - check printer dpi
                str,
                'P1\n'
            ];

            data2 = [
                '\nN\n',
                'q350\n', //  q=width in dots - check printer dpi
                'Q90\n', // Q=height in dots - check printer dpi
                'B0,10,0,9,4,2,150,N,"'+barcode+'"\n',
                'A0,165,0,3,1,1,N,"'+vCode+'"\n',
                'P1\n'
            ];

            //Regular label
            for (i = 0; i < countlabels; i++) {
                qz.print(config, data1).catch(function(e) { console.error(e); });
            }
            
            if (printbarcode) { 
                //Barcode label
                for (i = 0; i < countlabels; i++) {
                    qz.print(config, data2).catch(function(e) { console.error(e); });
                }
            }
            
        }

        function refreshLabelEPLButton(item, uom) {
            var vParams = "?item="+item+'&uom='+uom;
            $('.clsPrintLabelParameterCheck').each(function() {
                vParams = vParams + "&" + $(this).attr('id') + "=" + $(this).is(':checked');
            });

            $('.clsPrintLabelParameterSelect').each(function() {
                vParams = vParams + "&" + $(this).attr('id') + "=" + $(this).val();
            });

            ptoken.navigate('#session.root#/warehouse/maintenance/item/uom/uomlabel/itemUoMLabelButtonEPL.cfm' + vParams, 'divLabelButton');	
        }

    </script>

</cfoutput>