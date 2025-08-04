/*
 * Copyright © 2025 Promisan
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
var fdLocale = {
        fullMonths:[
                "Janvier",
                "F\u00E9vrier",
                "Mars",
                "Avril",
                "Mai",
                "Juin",
                "Juillet",
                "Ao\u00FBt",
                "Septembre",
                "Octobre",
                "Novembre",
                "D\u00E9cembre"
                ],
        fullDays:[
                "Lundi",
                "Mardi",
                "Mercredi",
                "Jeudi",
                "Vendredi",
                "Samedi",
                "Dimanche"
                ],
        dayAbbrs:[
                "Lun",
                "Mar",
                "Mer",
                "Jeu",
                "Ven",
                "Sam",
                "Dim"
                ],
        monthAbbrs:[
                "Jan",
                "F\u00E9v",
                "Mar",
                "Avr",
                "Mai",
                "Jui",
                "Juil",
                "Ao\u00FB",
                "Sep",
                "Oct",
                "Nov",
                "D\u00E9c"
                ],
        /* Only stipulate the firstDayOfWeek should the first day not be Monday           
        firstDayOfWeek:1,        
         */         
        titles:[
                "Mois pr\u00E9cedent",
                "Mois suivant",
                "Ann\u00E9e pr\u00E9cedente",
                "Ann\u00E9e suivante",
                "Aujourd\u2019hui",
                "Ouvrir Calendrier",
                "sm",
                "Semaine [[%0%]]/[[%1%]]",
                "Semaine",
                "Choissisez une date",
                "Cliquez et d\u00E9placez",
                "Montre \u201C[[%0%]]\u201D en premier",
                "Aujourd\u2019hui",
                "Date désactivé : "
                ]
};
try { datePickerController.loadLanguage(); } catch(err) {}
 
