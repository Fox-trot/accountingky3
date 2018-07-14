﻿#Область ПрограммныйИнтерфейс

// Возвращает структуру полей адреса для программного формирования адреса.
//
// Результат:
//    Структура - поля адреса:
//        * Представление    - Строка - текстовое представление адреса по административно-территориальному делению.
//        * МуниципальноеПредставление - Строка - текстовое представление адреса по муниципальному делению.
//        * ТипАдреса        - Строка - основной тип адреса (только для адресов РФ).
//                                      Варианты: "Муниципальный", "Административно-территориальный".
//        * Страна           - Строка - текстовое представление страны.
//        * КодСтраны        - Строка - код страны по ОКСМ.
//        * Индекс           - Строка - почтовый индекс.
//        * КодРегиона       - Строка - код региона РФ.
//        * Регион           - Строка - текстовое представление региона РФ.
//        * РегионСокращение - Строка - сокращение региона.
//        * Округ            - Строка - текстовое представление округа (устарело).
//        * ОкругСокращение  - Строка - сокращение округа (устарело).
//        * Район            - Строка - текстовое представление района у адресов по административно-территориальному делению.
//        * РайонСокращение  - Строка - сокращение района у адресов по административно-территориальному делению.
//        * МуниципальныйРайон - Строка - текстовое представление муниципального района у адресов по муниципальному делению.
//        * МуниципальныйРайонСокращение - Строка - сокращение муниципального района у адресов по муниципальному делению.
//        * Город            - Строка - текстовое представление города у адресов по административно-территориальному делению.
//        * ГородСокращение  - Строка - сокращение города  у адресов по административно-территориальному делению.
//        * Поселение            - Строка - текстовое представление поселения у адресов по муниципальному делению.
//        * ПоселениеСокращение  - Строка - сокращение поселения у адресов по муниципальному делению.
//        * ВнутригородскойРайон - Строка - текстовое представление внутригородского района.
//        * ВнутригородскойРайонСокращение  - Строка - сокращение внутригородского района.
//        * НаселенныйПункт  - Строка - текстовое представление населенного пункта.
//        * НаселенныйПунктСокращение - Строка - сокращение населенного пункта.
//        * Территория            - Строка - текстовое представление территории.
//        * ТерриторияСокращение  - Строка - сокращение территории.
//        * Улица            - Строка - текстовое представление улицы.
//        * УлицаСокращение  - Строка - сокращение улицы.
//        * ДополнительнаяТерритория - Строка - текстовое представление дополнительной территории (устарело).
//        * ДополнительнаяТерриторияСокращение - Строка - сокращение дополнительной территории (устарело).
//        * ЭлементДополнительнойТерритории - Строка - текстовое представление элемента дополнительной территории (устарело).
//        * ЭлементДополнительнойТерриторииСокращение - Строка - сокращение элемента дополнительной территории (устарело).
//        * Здание - Структура - структура с информацией о здании адреса.
//            ** ТипЗдания - Строка  - тип объекта адресации адреса РФ согласно приказу Минфина России от 5.11.2015 г. N
//                                     171н.
//            ** Номер - Строка  - текстовое представление номера дома (только для адресов РФ).
//        * Корпуса - Массив - содержит структуры(поля структуры: ТипКорпуса, Номер) с перечнем корпусов адреса.
//        * Помещения - Массив - содержит структуры(поля структуры: ТипПомещения, Номер) с перечнем помещений адреса.
//        * ИдентификаторАдресногоОбъекта - УникальныйИдентификатор - Идентификационный код последнего адресного объекта
//                                        в иерархи адреса. Например, для адреса: Москва г., Дмитровское ш., д.9 это
//                                        будет идентификатор улицы.
//        * ИдентификаторДома - УникальныйИдентификатор - Идентификационный код дома(строения) адресного объекта.
//        * Идентификаторы - Структура - Идентификаторы адресных объектов адреса.
//            ** РегионИдентификатор - УникальныйИдентификатор, Неопределено - идентификатор региона.
//            ** РайонИдентификатор - УникальныйИдентификатор, Неопределено - идентификатор района.
//            ** МуниципальныйРайонИдентификатор - УникальныйИдентификатор, Неопределено - идентификатор муниципального района.
//            ** ГородИдентификатор - УникальныйИдентификатор, Неопределено - идентификатор города.
//            ** ПоселениеИдентификатор - УникальныйИдентификатор, Неопределено - идентификатор поселения.
//            ** ВнутригородскойРайонИдентификатор - УникальныйИдентификатор, Неопределено - идентификатор
//                                                                                           внутригородского района.
//            ** НаселенныйПунктИдентификатор - УникальныйИдентификатор, Неопределено - идентификатор населенного пункта.
//            ** ТерриторияИдентификатор - УникальныйИдентификатор, Неопределено - идентификатор территории.
//            ** УлицаИдентификатор      - УникальныйИдентификатор, Неопределено - идентификатор улица.
//        * КодыКЛАДР           - Структура - Коды КЛАДР, если установлен параметр КодыКЛАДР.
//           ** Регион          - Строка    - Код КЛАДР региона.
//           ** Район           - Строка    - Код КЛАДР район.
//           ** Город           - Строка    - Код КЛАДР города.
//           ** НаселенныйПункт - Строка    - Код КЛАДР населенного пункта.
//           ** Улица           - Строка    - Код КЛАДР улица.
//        * ДополнительныеКоды  - Структура - Коды ОКТМО, ОКТМО, ОКАТО, КодИФНСФЛ, КодИФНСЮЛ, КодУчасткаИФНСФЛ, КодУчасткаИФНСЮЛ.
//        * Комментарий - Строка - комментарий к адресу.
//
Функция ПоляАдреса() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("ТипАдреса"                 , "");
	Результат.Вставить("Комментарий"               , "");
	
	Результат.Вставить("Представление"             , "");
	Результат.Вставить("МуниципальноеПредставление", "");
	
	Результат.Вставить("Страна"   , "");
	Результат.Вставить("КодСтраны", "");
	Результат.Вставить("Индекс"   , "");
	
	Результат.Вставить("КодРегиона"                               , "");
	Результат.Вставить("Регион"                                   , "");
	Результат.Вставить("РегионСокращение"                         , "");
	Результат.Вставить("Округ"                                    , "");
	Результат.Вставить("ОкругСокращение"                          , "");
	Результат.Вставить("Район"                                    , "");
	Результат.Вставить("РайонСокращение"                          , "");
	Результат.Вставить("МуниципальныйРайон"                       , "");
	Результат.Вставить("МуниципальныйРайонСокращение"             , "");
	Результат.Вставить("Город"                                    , "");
	Результат.Вставить("ГородСокращение"                          , "");
	Результат.Вставить("Поселение"                                , "");
	Результат.Вставить("ПоселениеСокращение"                      , "");
	Результат.Вставить("ВнутригородскойРайон"                     , "");
	Результат.Вставить("ВнутригородскойРайонСокращение"           , "");
	Результат.Вставить("НаселенныйПункт"                          , "");
	Результат.Вставить("НаселенныйПунктСокращение"                , "");
	Результат.Вставить("Территория"                               , "");
	Результат.Вставить("ТерриторияСокращение"                     , "");
	Результат.Вставить("Улица"                                    , "");
	Результат.Вставить("УлицаСокращение"                          , "");
	Результат.Вставить("ДополнительнаяТерритория"                 , "");
	Результат.Вставить("ДополнительнаяТерриторияСокращение"       , "");
	Результат.Вставить("ЭлементДополнительнойТерритории"          , "");
	Результат.Вставить("ЭлементДополнительнойТерриторииСокращение", "");
	
	Здание = Новый Структура;
	Здание.Вставить("ТипЗдания", "");
	Здание.Вставить("Номер"    , "");
	Результат.Вставить("Здание", Здание);
	
	Результат.Вставить("Корпуса"  , Новый Массив);
	Результат.Вставить("Помещения", Новый Массив);
	
	Результат.Вставить("ИдентификаторАдресногоОбъекта", Неопределено);
	Результат.Вставить("ИдентификаторДома"            , Неопределено);
	
	Идентификаторы = Новый Структура;
	Идентификаторы.Вставить("РегионИдентификатор"              , Неопределено);
	Идентификаторы.Вставить("РайонИдентификатор"               , Неопределено);
	Идентификаторы.Вставить("МуниципальныйРайонИдентификатор"  , Неопределено);
	Идентификаторы.Вставить("ГородИдентификатор"               , Неопределено);
	Идентификаторы.Вставить("ПоселениеИдентификатор"           , Неопределено);
	Идентификаторы.Вставить("ВнутригородскойРайонИдентификатор", Неопределено);
	Идентификаторы.Вставить("НаселенныйПунктИдентификатор"     , Неопределено);
	Идентификаторы.Вставить("ТерриторияИдентификатор"          , Неопределено);
	Идентификаторы.Вставить("УлицаИдентификатор"               , Неопределено);
	Результат.Вставить("Идентификаторы", Идентификаторы);
	
	ДополнительныеКоды = Новый Структура;
	ДополнительныеКоды.Вставить("ОКТМО"           , "");
	ДополнительныеКоды.Вставить("OKATO"           , "");
	ДополнительныеКоды.Вставить("КодИФНСФЛ"       , "");
	ДополнительныеКоды.Вставить("КодИФНСЮЛ"       , "");
	ДополнительныеКоды.Вставить("КодУчасткаИФНСФЛ", "");
	ДополнительныеКоды.Вставить("КодУчасткаИФНСЮЛ", "");
	Результат.Вставить("ДополнительныеКоды", ДополнительныеКоды);
	
	КодыКЛАДР = Новый Структура;
	КодыКЛАДР.Вставить("Регион"         , "");
	КодыКЛАДР.Вставить("Район"          , "");
	КодыКЛАДР.Вставить("Город"          , "");
	КодыКЛАДР.Вставить("НаселенныйПункт", "");
	КодыКЛАДР.Вставить("Улица"          , "");
	Результат.Вставить("КодыКЛАДР", КодыКЛАДР);
	
	Возврат Результат;
	
КонецФункции

#Область УстаревшиеПроцедурыИФункции

// Возвращает структуру контактной информации по типу.
// Для получения полей адреса следует использовать РаботаСАдресамиКлиентСервер.ПоляАдреса.
//
// Параметры:
//  ТипКИ - ПеречислениеСсылка.ТипыКонтактнойИнформации	 - тип контактной информации.
//  ФорматАдреса - Строка - Тип возвращаемой структуры в зависимости от формата адреса: "КЛАДР" или "ФИАС" информацию.
// 
// Возвращаемое значение:
//  Структура - пустая структура контактной информации, ключи - имена полей, значения поля.
//
Функция СтруктураКонтактнойИнформацииПоТипу(ТипКИ, ФорматАдреса = "КЛАДР") Экспорт
	
	Если ТипКИ = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		Возврат СтруктураПолейАдреса(ФорматАдреса);
	ИначеЕсли ТипКИ = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон") Тогда
		Возврат УправлениеКонтактнойИнформациейКлиентСервер.СтруктураПолейТелефона();
	Иначе
		Возврат Новый Структура;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ОсновнаяСтрана() Экспорт
	Возврат ПредопределенноеЗначение("Справочник.СтраныМира.Россия");
КонецФункции

Функция АккомодацияСтруктурыАдреса(Данные) Экспорт
	
	НаселенныйПунктДетально = ОписаниеНовойКонтактнойИнформации(ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес"));
	ЗаполнитьЗначенияСвойств(НаселенныйПунктДетально, Данные);
	
	Если ТипЗнч(НаселенныйПунктДетально.Buildings) <> Тип("Массив") Тогда
		НаселенныйПунктДетально.Buildings = Новый Массив;
	КонецЕсли;
	
	Если ТипЗнч(НаселенныйПунктДетально.Apartments) <> Тип("Массив") Тогда
		НаселенныйПунктДетально.Buildings = Новый Массив;
	КонецЕсли;
	
	Для каждого ЭлементАдреса Из НаселенныйПунктДетально Цикл
		
		Если СтрЗаканчиваетсяНа(ЭлементАдреса.Ключ, "Id")
			И ТипЗнч(ЭлементАдреса.Значение) = Тип("Строка")
			И СтрДлина(ЭлементАдреса.Значение) = 36 Тогда
				НаселенныйПунктДетально[ЭлементАдреса.Ключ] = Новый УникальныйИдентификатор(ЭлементАдреса.Значение);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Данные.Свойство("house") Тогда
		НаселенныйПунктДетально.HouseNumber = Данные.house;
	КонецЕсли;
	
	Возврат НаселенныйПунктДетально;
	
КонецФункции

// Возвращает XPath для района.
//
// Возвращаемое значение:
//      Строка - XPath
//
Функция XPathРайона() Экспорт
	
	Возврат "СвРайМО/Район";
	
КонецФункции

// Возвращает массив структур с информацией о частях адреса согласно приказу ФНС ММВ-7-1/525 от 31.08.2011.
//
// Возвращаемое значение:
//      Массив - содержит структуры - описания.
//
Функция ТипыОбъектовАдресацииАдресаРФ() Экспорт
	
	Результат = Новый Массив;
	
	// Код, Наименование, Тип, Порядок, КодФИАС
	// Тип: 1 - владение, 2 - здание, 3 - помещение.
	
	Результат.Добавить(СтрокаОбъектаАдресации("1010", НСтр("ru = 'Дом'"),          1, 1, 2));
	Результат.Добавить(СтрокаОбъектаАдресации("1020", НСтр("ru = 'Владение'"),     1, 2, 1));
	Результат.Добавить(СтрокаОбъектаАдресации("1030", НСтр("ru = 'Домовладение'"), 1, 3, 3));
	
	Результат.Добавить(СтрокаОбъектаАдресации("1050", НСтр("ru = 'Корпус'"),     2, 1));
	Результат.Добавить(СтрокаОбъектаАдресации("1060", НСтр("ru = 'Строение'"),   2, 2, 1));
	Результат.Добавить(СтрокаОбъектаАдресации("1080", НСтр("ru = 'Литера'"),     2, 3, 3));
	Результат.Добавить(СтрокаОбъектаАдресации("1090", НСтр("ru = 'Литер'"),      2, 6, 3));
	Результат.Добавить(СтрокаОбъектаАдресации("1070", НСтр("ru = 'Сооружение'"), 2, 4, 2));
	Результат.Добавить(СтрокаОбъектаАдресации("1040", НСтр("ru = 'Участок'"),    2, 5));
	
	Результат.Добавить(СтрокаОбъектаАдресации("2010", НСтр("ru = 'Квартира'"),  3, 1));
	Результат.Добавить(СтрокаОбъектаАдресации("2030", НСтр("ru = 'Офис'"),      3, 2));
	Результат.Добавить(СтрокаОбъектаАдресации("2040", НСтр("ru = 'Бокс'"),      3, 3));
	Результат.Добавить(СтрокаОбъектаАдресации("2020", НСтр("ru = 'Помещение'"), 3, 4));
	Результат.Добавить(СтрокаОбъектаАдресации("2050", НСтр("ru = 'Комната'"),   3, 5));
	Результат.Добавить(СтрокаОбъектаАдресации("2060", НСтр("ru = 'Этаж'"),      3, 6));
	Результат.Добавить(СтрокаОбъектаАдресации("2070", НСтр("ru = 'А/я'"),       3, 7));
	Результат.Добавить(СтрокаОбъектаАдресации("2080", НСтр("ru = 'В/ч'"),       3, 8));
	Результат.Добавить(СтрокаОбъектаАдресации("2090", НСтр("ru = 'П/о'"),       3, 9));
	//  Наши сокращения для поддержки обратной совместимости при парсинге.
	Результат.Добавить(СтрокаОбъектаАдресации("2010", НСтр("ru = 'кв.'"),       3, 6));
	Результат.Добавить(СтрокаОбъектаАдресации("2030", НСтр("ru = 'оф.'"),       3, 7));
	// Ввод помещения вручную.
	Результат.Добавить(СтрокаОбъектаАдресации("2000", НСтр("ru = ''"),          3, 0));
	
	// Уточняющие объекты
	Результат.Добавить(СтрокаОбъектаАдресации("10100000", НСтр("ru = 'Почтовый индекс'")));
	Результат.Добавить(СтрокаОбъектаАдресации("10200000", НСтр("ru = 'Адресная точка'")));
	Результат.Добавить(СтрокаОбъектаАдресации("10300000", НСтр("ru = 'Садовое товарищество'")));
	Результат.Добавить(СтрокаОбъектаАдресации("10400000", НСтр("ru = 'Элемент улично-дорожной сети, планировочной структуры дополнительного адресного элемента'")));
	Результат.Добавить(СтрокаОбъектаАдресации("10500000", НСтр("ru = 'Промышленная зона'")));
	Результат.Добавить(СтрокаОбъектаАдресации("10600000", НСтр("ru = 'Гаражно-строительный кооператив'")));
	Результат.Добавить(СтрокаОбъектаАдресации("10700000", НСтр("ru = 'Территория'")));
	
	Возврат Результат;
КонецФункции

Функция ЭтоМуниципальныйАдрес(ТипАдреса) Экспорт
	Возврат СтрСравнить(ТипАдреса, МуниципальныйАдрес()) = 0;
КонецФункции

Функция ЭтоАдминистративноТерриториальныйАдрес(ТипАдреса) Экспорт
	Возврат СтрСравнить(ТипАдреса, АдминистративноТерриториальныйАдрес()) = 0;
КонецФункции

Функция ЭтоОсновнаяСтрана(Страна) Экспорт
	Возврат СтрСравнить(ОсновнаяСтрана(), Страна) = 0;
КонецФункции

Функция АдминистративноТерриториальныйАдрес() Экспорт
	Возврат "Административно-территориальный";
КонецФункции

Функция МуниципальныйАдрес() Экспорт
	Возврат "Муниципальный";
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Описание национальных полей структуры контактной информации для хранения ее в формате JSON.
// Основной список полей определяется в одноименной функции общего модуля УправлениеКонтактнойИнформациейКлиентСервер.
//
//    ТипКонтактнойИнформации  - ПеречислениеСсылка.ТипыКонтактнойИнформации -
//                                Тип контактной информации, определяющий состав полей контактной информации.
//
// Возвращаемое значение:
//   Структура - Поля контактной информации добавленные к основным полям:
//     Для типа контактной информации адрес:
//     * ID - Строка -  Идентификационный код последнего адресного объекта в иерархи адреса.
//     * AddressType - Строка - установленный пользователем тип адреса(только для адресов РФ).
//                              Варианты: "Муниципальный", "Административно-территориальный".
//     * AreaCode - Строка - код региона РФ.
//     * AreaID - Строка - идентификатор региона.
//     * District - Строка - представление района у адресов по административно-территориальному делению.
//     * DistrictType - Строка - сокращение района у адресов по административно-территориальному делению.
//     * DistrictID - Строка - идентификатор региона у адресов по административно-территориальному делению.
//     * MunDistrict - Строка - представление муниципального района у адресов по муниципальному делению.
//     * MunDistrictType - Строка - сокращение муниципального района у адресов по муниципальному делению.
//     * MunDistrictID - Строка - идентификатор муниципального района у адресов по муниципальному делению.
//     * CityID - Строка - идентификатор муниципального города у адресов по административно-территориальному делению.
//     * Settlement - Строка - представление поселения у адресов по муниципальному делению.
//     * SettlementType - Строка - сокращение поселения у адресов по муниципальному делению.
//     * SettlementID - Строка - идентификатор поселения.
//     * CityDistrict - Строка - представление внутригородского района.
//     * CityDistrictType - Строка - сокращение внутригородского района.
//     * CityDistrictID - Строка - идентификатор внутригородского района.
//     * Territory - Строка - представление территории.
//     * TerritoryType - Строка - сокращение территории.
//     * TerritoryID - Строка - идентификатор территории.
//     * Locality - Строка - представление населенного пункта.
//     * LocalityType - Строка - сокращение населенного пункта.
//     * LocalityID - Строка - идентификатор населенного пункта.
//     * StreetID - Строка - идентификатор улицы.
//     * HouseType - Строка - тип дома, владения.
//     * HouseNumber - Строка - номер дома, владения.
//     * HouseID - Строка - идентификатор дома.
//     * Buildings - Массив - содержит структуры(поля структуры: Type, Number) с перечнем корпусов (строений) адреса.
//     * Apartments - Массив - содержит структуры(поля структуры: Type, Number) с перечнем помещений адреса.
//     * CodeKLADR - Строка - Код КЛАДР.
//     * OKTMO - Строка - Код ОКТМО.
//     * OKATO - Строка - Код ОКАТО.
//     * IFNSFLCode - Строка - Код ИФНСФЛ.
//     * IFNSULCode - Строка - Код ИФНСЮЛ.
//     * IFNSFLAreaCode - Строка - Код участка ИФНСФЛ.
//     * IFNSULAreaCode - Строка - Код участка ИФНСЮЛ.
//
Функция ОписаниеНовойКонтактнойИнформации(Знач ТипКонтактнойИнформации) Экспорт
	
	Если ТипЗнч(ТипКонтактнойИнформации) <> Тип("ПеречислениеСсылка.ТипыКонтактнойИнформации") Тогда
		ТипКонтактнойИнформации = "";
	КонецЕсли;
	
	Результат = УправлениеКонтактнойИнформациейКлиентСервер.ОписаниеНовойКонтактнойИнформации(ТипКонтактнойИнформации);
	
	Если ТипКонтактнойИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		
		Результат.Вставить("id",               "");
		Результат.Вставить("areaCode",         "");
		Результат.Вставить("areaId",           "");
		Результат.Вставить("district",         "");
		Результат.Вставить("districtType",     "");
		Результат.Вставить("districtId",       "");
		Результат.Вставить("munDistrict",      "");
		Результат.Вставить("munDistrictType",  "");
		Результат.Вставить("munDistrictId",    "");
		Результат.Вставить("cityId",           "");
		Результат.Вставить("settlement",       "");
		Результат.Вставить("settlementType",   "");
		Результат.Вставить("settlementId",     "");
		Результат.Вставить("cityDistrict",     "");
		Результат.Вставить("cityDistrictType", "");
		Результат.Вставить("cityDistrictId",   "");
		Результат.Вставить("territory",        "");
		Результат.Вставить("territoryType",    "");
		Результат.Вставить("territoryId",      "");
		Результат.Вставить("locality",         "");
		Результат.Вставить("localityType",     "");
		Результат.Вставить("localityId",       "");
		Результат.Вставить("streetId",         "");
		Результат.Вставить("houseType",        "");
		Результат.Вставить("houseNumber",      "");
		Результат.Вставить("houseId",          "");
		Результат.Вставить("buildings",        Новый Массив);
		Результат.Вставить("apartments",       Новый Массив);
		Результат.Вставить("codeKLADR",        "");
		Результат.Вставить("oktmo",            "");
		Результат.Вставить("okato",            "");
		Результат.Вставить("asInDocument",     "");
		Результат.Вставить("ifnsFLCode",       "");
		Результат.Вставить("ifnsULCode",       "");
		Результат.Вставить("ifnsFLAreaCode",   "");
		Результат.Вставить("ifnsULAreaCode",   "");
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает код дополнительной части адреса для сериализации.
//
//  Параметры:
//      СтрокаЗначения - Строка - значение для поиска, например "Дом", "Корпус", "Литера".
//
// Возвращаемое значение:
//      Число - код
// 
Функция КодСериализацииОбъектаАдресации(СтрокаЗначения) Экспорт
	
	Ключ = ВРег(СокрЛП(СтрокаЗначения));
	Для Каждого Элемент Из ТипыОбъектовАдресацииАдресаРФ() Цикл
		Если Элемент.Ключ = Ключ Тогда
			Возврат Элемент.Код;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

// Возвращает код дополнительной части адреса для почтового индекса.
//
// Возвращаемое значение:
//      Строка - код
//
Функция КодСериализацииПочтовогоИндекса() Экспорт
	
	Возврат КодСериализацииОбъектаАдресации(НСтр("ru = 'Почтовый индекс'"));
	
КонецФункции

// Возвращает XPath для почтового индекса.
//
// Возвращаемое значение:
//      Строка - XPath
//
Функция XPathПочтовогоИндекса() Экспорт
	
	Возврат "ДопАдрЭл[ТипАдрЭл='" + КодСериализацииПочтовогоИндекса() + "']";
	
КонецФункции

Функция КодСериализацииДополнительногоОбъектаАдресации(Уровень, ТипаАдресногоЭлемента = "")
	
	Если Уровень = 90 Тогда
		Если ВРег(ТипаАдресногоЭлемента) = "ГСК" Тогда
			Возврат "10600000";
		ИначеЕсли ВРег(ТипаАдресногоЭлемента) = "СНТ" Тогда
			Возврат "10300000";
		ИначеЕсли ВРег(ТипаАдресногоЭлемента) = "ТЕР" Тогда
			Возврат "10700000";
		Иначе
			Возврат "10200000";
		КонецЕсли;
	ИначеЕсли Уровень = 91 Тогда
		Возврат "10400000";
	КонецЕсли;
	
	// Все остальное - считаем ориентиром.
	Возврат "Местоположение";
КонецФункции

// Возвращает XPath для дополнительного объекта адресации по умолчанию.
//
//  Параметры;
//      Уровень - Число - уровень объекта. 90  - дополнительный(Варианты: ГСК, СНТ, ТЕР), 91 - подчиненный, -1 -
//                        Ориентир.
//
// Возвращаемое значение:
//      Строка - XPath
//
Функция XPathДополнительногоОбъектаАдресации(Уровень, ТипаАдресногоЭлемента = "") Экспорт
	КодСериализации = КодСериализацииДополнительногоОбъектаАдресации(Уровень, ТипаАдресногоЭлемента);
	Возврат "ДопАдрЭл[ТипАдрЭл='" + КодСериализации + "']";
КонецФункции

// Возвращает XPath для номера дополнительного объекта адресации.
//
//  Параметры;
//      СтрокаЗначения - Строка - искомый тип, например "Дом", "Корпус".
//
// Возвращаемое значение:
//      Строка - XPath
//
Функция XPathНомераДополнительногоОбъектаАдресации(СтрокаЗначения) Экспорт
	
	Код = КодСериализацииОбъектаАдресации(СтрокаЗначения);
	Если Код = Неопределено Тогда
		Код = СтрЗаменить(СтрокаЗначения, "'", "");
	КонецЕсли;
	
	Возврат "ДопАдрЭл/Номер[Тип='" + Код + "']";
КонецФункции

// Возвращает строку с описанием типа по коду части адреса.
//  Противоположность функции "КодСериализацииОбъектаАдресации".
//
// Параметры:
//      Код - Строка - код
//
// Возвращаемое значение:
//      Число - Тип
//
Функция ТипОбъектаПоКодуСериализации(Код) Экспорт
	Для Каждого Элемент Из ТипыОбъектовАдресацииАдресаРФ() Цикл
		Если Элемент.Код = Код Тогда
			Возврат Элемент;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

// Возвращает массив вариантов наименований по типу (по признаку владения, строения, и т.п).
//
// Параметры:
//      Тип                  - Число  - запрашиваемый тип.
//      ДопускатьПовторыКода - Булево - Истина - будут возвращены все варианты с повторами ("квартира" - "кв." и т.п.).
//
// Возвращаемое значение:
//      Массив - содержит структуры - описания.
//
Функция НаименованияОбъектовАдресацииПоТипу(Тип, ДопускатьПовторыКода = Истина) Экспорт
	Результат = Новый Массив;
	Повторы   = Новый Соответствие;
	
	Для Каждого Элемент Из ТипыОбъектовАдресацииАдресаРФ() Цикл
		Если Элемент.Тип = Тип Тогда
			Если ДопускатьПовторыКода Тогда
				Результат.Добавить(Элемент.Наименование);
			Иначе
				Если Повторы.Получить(Элемент.Код) = Неопределено Тогда
					Результат.Добавить(Элемент.Наименование);
				КонецЕсли;
				Повторы.Вставить(Элемент.Код, Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции    

// Возвращает сокращения частей адреса
//
// Возвращаемое значение:
//      Соответствие - Список сокращений.
//
Функция СокращенияОбъектовАдресацииАдресаРФ() Экспорт
	
	Результат = Новый Соответствие;
	
	Результат.Вставить(НСтр("ru = 'Дом'"), НСтр("ru = 'Д.'"));
	Результат.Вставить(НСтр("ru = 'Владение'"), НСтр("ru = 'Вл.'"));
	Результат.Вставить(НСтр("ru = 'Домовладение'"), НСтр("ru = 'Домовл.'"));
	
	Результат.Вставить(НСтр("ru = 'Корпус'"), НСтр("ru = 'Корп.'"));
	Результат.Вставить(НСтр("ru = 'Строение'"), НСтр("ru = 'Стр.'"));
	Результат.Вставить(НСтр("ru = 'Литера'"), НСтр("ru = 'Лит.'"));
	Результат.Вставить(НСтр("ru = 'Сооружение'"), НСтр("ru = 'Сооруж.'"));
	Результат.Вставить(НСтр("ru = 'Участок'"), НСтр("ru = 'Уч.'"));
	
	Результат.Вставить(НСтр("ru = 'Квартира'"), НСтр("ru = 'Кв.'"));
	Результат.Вставить(НСтр("ru = 'Офис'"), НСтр("ru = 'Оф.'"));
	Результат.Вставить(НСтр("ru = 'Бокс'"), НСтр("ru = 'Бокс'"));
	Результат.Вставить(НСтр("ru = 'Помещение'"), НСтр("ru = 'Пом.'"));
	Результат.Вставить(НСтр("ru = 'Комната'"), НСтр("ru = 'Ком.'"));
	Результат.Вставить(НСтр("ru = 'Этаж'"), НСтр("ru = 'Этаж'"));
	Результат.Вставить(НСтр("ru = 'А/я'"), НСтр("ru = 'а/я'"));
	Результат.Вставить(НСтр("ru = 'П/о'"), НСтр("ru = 'п/о'"));
	Результат.Вставить(НСтр("ru = 'В/ч'"), НСтр("ru = 'в/ч'"));
	
	Возврат Результат;
КонецФункции

Функция СтрокаОбъектаАдресации(Код, Наименование, Тип = 0, Порядок = 0, КодФИАС = 0)
	
	СтруктураОбъектаАдресации = Новый Структура;
	СтруктураОбъектаАдресации.Вставить("Код", Код);
	СтруктураОбъектаАдресации.Вставить("Наименование", Наименование);
	СтруктураОбъектаАдресации.Вставить("Тип", Тип);
	СтруктураОбъектаАдресации.Вставить("Порядок", Порядок);
	СтруктураОбъектаАдресации.Вставить("КодФИАС", КодФИАС);
	СтруктураОбъектаАдресации.Вставить("Сокращение", НРег(Наименование));
	СтруктураОбъектаАдресации.Вставить("Ключ", ВРег(Наименование));
	Возврат СтруктураОбъектаАдресации;
	
КонецФункции

Функция СопоставлениеУровняАдресаИНаименования(ТипАдреса, ВключатьУлицу)
	Уровни = Новый Соответствие;
	
	Уровни.Вставить(1, "Area");
	Если ЭтоМуниципальныйАдрес(ТипАдреса) Тогда
		Уровни.Вставить(31, "MunDistrict");
		Уровни.Вставить(41, "Settlement");
	Иначе
		Уровни.Вставить(3, "District");
		Уровни.Вставить(4, "City");
	КонецЕсли;
	
	Уровни.Вставить(5, "CityDistrict");
	Уровни.Вставить(6, "Locality");
	Уровни.Вставить(65, "Territory");
	
	Если ВключатьУлицу Тогда
		Уровни.Вставить(7, "Street");
	КонецЕсли;
	
	Возврат Уровни;
КонецФункции

Функция СопоставлениеНаименованиеУровнюАдреса(ИмяУровня) Экспорт
	Уровни = Новый Соответствие;
	
	Уровни.Вставить("Area", 1);
	Уровни.Вставить("MunDistrict", 31);
	Уровни.Вставить("Settlement", 41);
	Уровни.Вставить("District", 3);
	Уровни.Вставить("City", 4);
	Уровни.Вставить("CityDistrict", 5);
	Уровни.Вставить("Locality", 6);
	Уровни.Вставить("Territory", 65);
	Уровни.Вставить("Street", 7);
	
	Возврат Уровни[ИмяУровня];
КонецФункции

Функция ИменаУровнейАдреса(ТипАдреса, ВключатьУлицу) Экспорт
	Уровни = Новый Массив;
	
	Если ТипАдреса = УправлениеКонтактнойИнформациейКлиентСервер.ИностранныйАдрес() Тогда
		
		Уровни.Добавить("City");
		
	Иначе
		
		Уровни.Добавить("Area");
		Если ТипАдреса = УправлениеКонтактнойИнформациейКлиентСервер.АдресЕАЭС() Тогда
			
			Уровни.Добавить("District");
			Уровни.Добавить("City");
			Уровни.Добавить("Locality");
			
		Иначе
			
			Если ТипАдреса = "Все" Тогда
				Уровни.Добавить("District");
				Уровни.Добавить("City");
				Уровни.Добавить("MunDistrict");
				Уровни.Добавить("Settlement");
			Иначе
				Если ЭтоМуниципальныйАдрес(ТипАдреса) Тогда
					Уровни.Добавить("MunDistrict");
					Уровни.Добавить("Settlement");
				Иначе
					Уровни.Добавить("District");
					Уровни.Добавить("City");
				КонецЕсли;
			КонецЕсли;
			
			Уровни.Добавить("CityDistrict");
			Уровни.Добавить("Locality");
			Уровни.Добавить("Territory");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВключатьУлицу Тогда
			Уровни.Добавить("Street");
		КонецЕсли;
	Возврат Уровни;
	
КонецФункции

Функция ПредставлениеУровняБезСокращения(ИмяУровня) Экспорт
	
	Если ИмяУровня = "MunDistrict" ИЛИ ИмяУровня = "Settlement" Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ИдентификаторАдреса(Адрес, ВключатьУлицу) Экспорт
	
	ИдентификаторАдреса = Неопределено;
	МаксимальныйУровень = 0;
	Уровни = СопоставлениеУровняАдресаИНаименования(Адрес.AddressType, ВключатьУлицу);
	
	Для каждого Уровень Из Уровни Цикл
		УровеньКлюч = ?(Уровень.Ключ < 10, Уровень.Ключ * 10, Уровень.Ключ);
		Если УровеньКлюч > МаксимальныйУровень
			И Адрес.Свойство(Уровень.Значение + "Id")
			И ЗначениеЗаполнено(Адрес[Уровень.Значение + "Id"]) Тогда
				ИдентификаторАдреса = Адрес[Уровень.Значение + "Id"];
				МаксимальныйУровень = УровеньКлюч;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ИдентификаторАдреса;
	
КонецФункции

// Преобразует введенные английские буквы к русской раскладке при подборе адреса
//
Процедура ПреобразоватьВводАдреса(Текст) Экспорт
	РусскиеКлавиши = "ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁ";
	АнглийскиеКлавиши = "QWERTYUIOP[]ASDFGHJKL;'ZXCVBNM,.`";
	Текст = ВРег(Текст);
	Для Позиция = 0 По СтрДлина(Текст) Цикл
		Символ = Сред(Текст, Позиция, 1);
		ПозицияСимвола = СтрНайти(АнглийскиеКлавиши, Символ);
		Если ПозицияСимвола > 0 Тогда
			Текст = СтрЗаменить(Текст, Символ, Сред(РусскиеКлавиши, ПозицияСимвола, 1));
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПредставлениеНаселенногоПунктаАдреса(Адрес) Экспорт
	
	СписокЗаполненныхУровней = Новый Массив;
	
	Для каждого ИмяУровня Из ИменаУровнейАдреса(Адрес.AddressType, Ложь) Цикл
		
		Если ЗначениеЗаполнено(Адрес[ИмяУровня]) Тогда
			Если НЕ ПредставлениеУровняБезСокращения(ИмяУровня) Тогда
				СписокЗаполненныхУровней.Добавить(Адрес[ИмяУровня] + " " + Адрес[ИмяУровня + "Type"]);
			Иначе
				СписокЗаполненныхУровней.Добавить(Адрес[ИмяУровня]);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрСоединить(СписокЗаполненныхУровней, ", ");
	
КонецФункции

Процедура ОбновитьПредставлениеАдреса(Адрес, ВключатьСтрануВПредставление) Экспорт
	
	Представление = ПредставлениеАдреса(Адрес, ВключатьСтрануВПредставление);
	Адрес.Value = Представление;
	
КонецПроцедуры

Функция ПредставлениеАдреса(Адрес, ВключатьСтрануВПредставление, ТипАдреса = Неопределено) Экспорт
	
	Если ТипЗнч(Адрес) <> Тип("Структура") Тогда
		ВызватьИсключение НСтр("ru='Для формирования представления адреса передан некорректный тип адреса'");
	КонецЕсли;
	
	Если ТипАдреса = Неопределено Тогда
		ТипАдреса = Адрес.AddressType;
	КонецЕсли;
	
	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоАдресВСвободнойФорме(ТипАдреса) Тогда
		
		Если Не Адрес.Свойство("Country") Или ПустаяСтрока(Адрес.Country) Тогда
			Возврат Адрес.Value;
		КонецЕсли;
		
		ВПредставлениеЕстьСтрана = СтрНачинаетсяС(ВРег(Адрес.Value), ВРег(Адрес.Country));
		Если ВключатьСтрануВПредставление Тогда
			Если Не ВПредставлениеЕстьСтрана Тогда
				Возврат Адрес.Country + ", " + Адрес.Value;
			КонецЕсли;
		Иначе
			Если ВПредставлениеЕстьСтрана И СтрНайти(Адрес.Value, ",") > 0 Тогда
				СписокПолей = СтрРазделить(Адрес.Value, ",");
				СписокПолей.Удалить(0);
				Возврат СтрСоединить(СписокПолей, ",");
			КонецЕсли;
		КонецЕсли;
		
		Возврат Адрес.Value;
		
	КонецЕсли;
	
	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоАдресВСвободнойФорме(ТипАдреса) Тогда
		Возврат ПредставлениеАдресаВСвободнойФорме(Адрес, ВключатьСтрануВПредставление);
	КонецЕсли;
	
	СписокЗаполненныхУровней = Новый Массив;
	
	НаименованиеСтраны = "";
	Если ВключатьСтрануВПредставление И Адрес.Свойство("Country") И НЕ ПустаяСтрока(Адрес.Country) Тогда
		СписокЗаполненныхУровней.Добавить(Адрес.Country);
		НаименованиеСтраны = Адрес.Country;
	КонецЕсли;
	
	Если Адрес.Свойство("ZipCode") И НЕ ПустаяСтрока(Адрес.ZipCode) Тогда
		СписокЗаполненныхУровней.Добавить(Адрес.ZipCode);
	КонецЕсли;
	
	Для каждого ИмяУровня Из ИменаУровнейАдреса(ТипАдреса, Истина) Цикл
		
		Если Адрес.Свойство(ИмяУровня) И НЕ ПустаяСтрока(Адрес[ИмяУровня]) Тогда
			Если НЕ ПредставлениеУровняБезСокращения(ИмяУровня) Тогда
				СписокЗаполненныхУровней.Добавить(СокрЛП(Адрес[ИмяУровня] + " " + Адрес[ИмяУровня + "Type"]));
			Иначе
				СписокЗаполненныхУровней.Добавить(Адрес[ИмяУровня]);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Адрес.Свойство("HouseNumber") И НЕ ПустаяСтрока(Адрес.HouseNumber) Тогда
		СписокЗаполненныхУровней.Добавить(НРег(Адрес.HouseType) + " № " + Адрес.HouseNumber);
	КонецЕсли;
	
	Если Адрес.Свойство("Buildings") И Адрес.Buildings.Количество() > 0 Тогда
		
		Для каждого Строение Из Адрес.Buildings Цикл
			СписокЗаполненныхУровней.Добавить(НРег(Строение.Type) + " " + Строение.Number);
		КонецЦикла;
		
	КонецЕсли;
	
	Если Адрес.Свойство("Apartments")
		И Адрес.Apartments <> Неопределено
		И Адрес.Apartments.Количество() > 0 Тогда
		
		Для каждого Строение Из Адрес.Apartments Цикл
			Если СтрСравнить(Строение.Type, "Другое") <> 0 Тогда
				СписокЗаполненныхУровней.Добавить(НРег(Строение.Type) + " " + Строение.Number);
			Иначе
				СписокЗаполненныхУровней.Добавить(Строение.Number);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Представление = СтрСоединить(СписокЗаполненныхУровней, ", ");
	
	Возврат ?(СтрСравнить(Представление, НаименованиеСтраны) <> 0, Представление, "");
	
КонецФункции

#Область ПрочиеСлужебныеПроцедурыИФункции

Функция ПредставлениеАдресаВСвободнойФорме(Знач Адрес, Знач ВключатьСтрануВПредставление)
	
	Если ВключатьСтрануВПредставление И Адрес.Свойство("Country") И НЕ ПустаяСтрока(Адрес.Country) Тогда
		ЧастиАдреса = СтрРазделить(Адрес.Value, ",");
		Если ЗначениеЗаполнено(Адрес.Value) И СтрСравнить(ЧастиАдреса[0], Адрес.Country) = 0 Тогда
			ЧастиАдреса.Удалить(0);
			Адрес.Value = СтрСоединить(ЧастиАдреса, ",");
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Адрес.Value;
	
КонецФункции

Функция КонструкторРезультатаВыбора() Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("РегионЗагружен",             Неопределено);
	Результат.Вставить("Идентификатор",              "");
	Результат.Вставить("Представление",              "");
	Результат.Вставить("КраткоеПредставлениеОшибки", "");
	Результат.Вставить("Отказ",                      Ложь);
	Результат.Вставить("Уровень",                    0);
	Возврат Результат;

КонецФункции

// Возвращает пустую структура адреса.
//
// Возвращаемое значение:
//    Структура - адрес, ключи - имена полей, значения поля.
//
Функция СтруктураПолейАдреса(ФорматАдреса)
	
	СтруктураАдреса = Новый Структура;
	СтруктураАдреса.Вставить("Представление", "");
	СтруктураАдреса.Вставить("Страна", "");
	СтруктураАдреса.Вставить("НаименованиеСтраны", "");
	СтруктураАдреса.Вставить("КодСтраны","");
	СтруктураАдреса.Вставить("Индекс","");
	СтруктураАдреса.Вставить("Регион","");
	СтруктураАдреса.Вставить("РегионСокращение","");
	СтруктураАдреса.Вставить("Район","");
	СтруктураАдреса.Вставить("РайонСокращение","");
	СтруктураАдреса.Вставить("Город","");
	СтруктураАдреса.Вставить("ГородСокращение","");
	СтруктураАдреса.Вставить("НаселенныйПункт","");
	СтруктураАдреса.Вставить("НаселенныйПунктСокращение","");
	СтруктураАдреса.Вставить("Улица","");
	СтруктураАдреса.Вставить("УлицаСокращение","");
	СтруктураАдреса.Вставить("Дом","");
	СтруктураАдреса.Вставить("Корпус","");
	СтруктураАдреса.Вставить("Квартира","");
	СтруктураАдреса.Вставить("ТипДома","");
	СтруктураАдреса.Вставить("ТипКорпуса","");
	СтруктураАдреса.Вставить("ТипКвартиры","");
	СтруктураАдреса.Вставить("НаименованиеВида","");
	
	Если ВРег(ФорматАдреса) = "ФИАС" Тогда
		СтруктураАдреса.Вставить("Округ","");
		СтруктураАдреса.Вставить("ОкругСокращение","");
		СтруктураАдреса.Вставить("ВнутригородскойРайон","");
		СтруктураАдреса.Вставить("ВнутригородскойРайонСокращение","");
	КонецЕсли;
	
	Возврат СтруктураАдреса;
	
КонецФункции

// Возвращает строку списка полей.
//
// Параметры:
//    СоответствиеПолей - СписокЗначений - соответствия полей.
//    БезПустыхПолей    - Булево - необязательный флаг сохранения полей с пустыми значениями.
//
//  Возвращаемое значение:
//     Строка - результат, преобразованный из списка.
//
Функция ПреобразоватьСписокПолейВСтроку(СоответствиеПолей, БезПустыхПолей = Истина) Экспорт
	
	КвартираДобавлена = Ложь;
	КорпусДобавлен = Ложь;
	ПредыдущиеЗначение = Неопределено;
	
	СтруктураЗначенийПолей = Новый Структура;
	Для Каждого Элемент Из СоответствиеПолей Цикл
		
		Если Элемент.Представление = "Корпус" ИЛИ Элемент.Представление = "ТипКорпуса" Тогда
			Если ПредыдущиеЗначение <> Неопределено И ПредыдущиеЗначение.Представление = "ТипКорпуса"
				И ПредыдущиеЗначение.Значение = "Корпус" Тогда
				СтруктураЗначенийПолей.Вставить(Элемент.Представление, Элемент.Значение);
				КорпусДобавлен = Истина;
			ИначеЕсли НЕ КорпусДобавлен Тогда
				СтруктураЗначенийПолей.Вставить(Элемент.Представление, Элемент.Значение);
			КонецЕсли;
		ИначеЕсли Элемент.Представление = "Квартира" ИЛИ Элемент.Представление = "ТипКвартиры" Тогда
			Если ПредыдущиеЗначение <> Неопределено И ПредыдущиеЗначение.Представление = "ТипКвартиры"
				И ПредыдущиеЗначение.Значение = "Квартира" Тогда
				СтруктураЗначенийПолей.Вставить(Элемент.Представление, Элемент.Значение);
				КвартираДобавлена = Истина;
			ИначеЕсли НЕ КвартираДобавлена Тогда
				СтруктураЗначенийПолей.Вставить(Элемент.Представление, Элемент.Значение);				
			КонецЕсли;
		Иначе
			СтруктураЗначенийПолей.Вставить(Элемент.Представление, Элемент.Значение);	
		КонецЕсли;
		ПредыдущиеЗначение = Элемент;
	КонецЦикла;
	
	Возврат СтрокаПолей(СтруктураЗначенийПолей, БезПустыхПолей);
КонецФункции

//  Возвращает строку списка полей.
//
//  Параметры:
//    СтруктураЗначенийПолей - Структура - структура значений полей.
//    БезПустыхПолей         - Булево - необязательный флаг сохранения полей с пустыми значениями.
//
//  Возвращаемое значение:
///     Строка - результат преобразования из структуры.
//
Функция СтрокаПолей(СтруктураЗначенийПолей, БезПустыхПолей = Истина) Экспорт
	
	Результат = "";
	Для Каждого ЗначениеПоля Из СтруктураЗначенийПолей Цикл
		Если БезПустыхПолей И ПустаяСтрока(ЗначениеПоля.Значение) Тогда
			Продолжить;
		КонецЕсли;
		
		Результат = Результат + ?(Результат = "", "", Символы.ПС)
		            + ЗначениеПоля.Ключ + "=" + СтрЗаменить(ЗначениеПоля.Значение, Символы.ПС, Символы.ПС + Символы.Таб);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#КонецОбласти
