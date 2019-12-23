﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаПлатежиПоНалогуНаПрибыль(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.СуммаНачислено КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПлатежиПоНалогуНаПрибыль", РезультатЗапроса.Выгрузить());
КонецПроцедуры 

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Дата КАК Дата,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.СуммаНачислено КАК СуммаНачислено
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ТекущийРасчетНалогаНаПрибыль КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТаблицаПлатежиПоНалогуНаПрибыль(ДокументСсылка, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ИнтерфейсПечати

// Функция формирует табличный документ с печатной формой НДС
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьНалогаНаПрибыль(МассивОбъектов, ОбъектыПечати)	
	
	Запрос = Новый Запрос;		
	Запрос.Текст =	
		"ВЫБРАТЬ
		|	ТекущийРасчетНалогаНаПрибыль.Ссылка КАК Ссылка,
		|	ТекущийРасчетНалогаНаПрибыль.Дата КАК Дата,
		|	ТекущийРасчетНалогаНаПрибыль.Организация КАК Организация,
		|	ТекущийРасчетНалогаНаПрибыль.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ТекущийРасчетНалогаНаПрибыль.Организация.КодПоОКПО КАК ОрганизацияКодПоОКПО,
		|	ТекущийРасчетНалогаНаПрибыль.Организация.ИНН КАК ОрганизацияИНН,
		|	ТекущийРасчетНалогаНаПрибыль.Организация.ГНС КАК ОрганизацияГНС,
		|	ТекущийРасчетНалогаНаПрибыль.Организация.ГНС.Код КАК ОрганизацияКодГНС,
		|	ТекущийРасчетНалогаНаПрибыль.СуммаДоходов КАК СуммаДоходов,
		|	ТекущийРасчетНалогаНаПрибыль.СуммаРасходов КАК СуммаРасходов,
		|	ТекущийРасчетНалогаНаПрибыль.База КАК База,
		|	ТекущийРасчетНалогаНаПрибыль.СтавкаНалогаНаПрибыль КАК СтавкаНалогаНаПрибыль,
		|	ТекущийРасчетНалогаНаПрибыль.СуммаНП КАК СуммаНП,
		|	ТекущийРасчетНалогаНаПрибыль.СуммаНППредыдущийКвартал КАК СуммаНППредыдущийКвартал,
		|	ТекущийРасчетНалогаНаПрибыль.СуммаНачислено КАК СуммаНачислено
		|ИЗ
		|	Документ.ТекущийРасчетНалогаНаПрибыль КАК ТекущийРасчетНалогаНаПрибыль
		|ГДЕ
		|	ТекущийРасчетНалогаНаПрибыль.Ссылка В (&МассивОбъектов)";	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ТекущийРасчетНалогаНаПрибыль_ТекущийРасчетНалогаНаПрибыль";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ТекущийРасчетНалогаНаПрибыль.ПФ_MXL_ТекущийРасчетНалогаНаПрибыль");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ИмяМакета = "ОтчетПоНДСОсновной";

	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		НачалоПериода = НачалоГода(Шапка.Дата);
		КонецПериода  = КонецКвартала(Шапка.Дата);
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Организация", 	Шапка.Организация);
		СтруктураПараметров.Вставить("НачалоПериода", 	НачалоПериода);
		СтруктураПараметров.Вставить("КонецПериода", 	КонецПериода);

		ОКПО	= Шапка.ОрганизацияКодПоОКПО;
		ИНН 	= Шапка.ОрганизацияИНН;
		КодГНС 	= Шапка.ОрганизацияКодГНС;
		
		КонтактныеДанные = ПолучитьКонтактнуюИнформацию(Шапка.Организация);
		
		Индекс           = КонтактныеДанные.Индекс;
		АдрОбластьГород  = КонтактныеДанные.АдрОбластьГород;
		ЮрАдрес	         = КонтактныеДанные.АдресОрганизации; 
		Телефон		     = КонтактныеДанные.Телефон;	
				
		ОбластьШапка.Параметры.ОрганизацияНаименованиеПолное =  Шапка.ОрганизацияНаименованиеПолное;
		
		Если ЗначениеЗаполнено(АдрОбластьГород) Тогда 
			ОбластьШапка.Параметры.АдресГород = АдрОбластьГород;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ЮрАдрес) Тогда 
			ОбластьШапка.Параметры.АдресУлица = ЮрАдрес;
		КонецЕсли;
		
		ОбластьШапка.Параметры.Телефон = Телефон;
		
		Если ЗначениеЗаполнено(Индекс) Тогда
			
			ОбластьШапка.Параметры.ИНД1 = Сред(Индекс,1,1);
			ОбластьШапка.Параметры.ИНД2 = Сред(Индекс,2,1);
			ОбластьШапка.Параметры.ИНД3 = Сред(Индекс,3,1);
			ОбластьШапка.Параметры.ИНД4 = Сред(Индекс,4,1);
			ОбластьШапка.Параметры.ИНД5 = Сред(Индекс,5,1);
			ОбластьШапка.Параметры.ИНД6 = Сред(Индекс,6,1);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОКПО) Тогда 
			ОбластьШапка.Параметры.ОКПО1 = Сред(ОКПО,1,1);
			ОбластьШапка.Параметры.ОКПО2 = Сред(ОКПО,2,1);
			ОбластьШапка.Параметры.ОКПО3 = Сред(ОКПО,3,1);
			ОбластьШапка.Параметры.ОКПО4 = Сред(ОКПО,4,1);
			ОбластьШапка.Параметры.ОКПО5 = Сред(ОКПО,5,1);
			ОбластьШапка.Параметры.ОКПО6 = Сред(ОКПО,6,1);
			ОбластьШапка.Параметры.ОКПО7 = Сред(ОКПО,7,1);
			ОбластьШапка.Параметры.ОКПО8 = Сред(ОКПО,8,1);
		КонецЕсли;
		
		ОбластьШапка.Параметры.ИНН1 = Сред(ИНН, 1, 1);
		ОбластьШапка.Параметры.ИНН2 = Сред(ИНН, 2, 1);
		ОбластьШапка.Параметры.ИНН3 = Сред(ИНН, 3, 1);                           
		ОбластьШапка.Параметры.ИНН4 = Сред(ИНН, 4, 1);
		ОбластьШапка.Параметры.ИНН5 = Сред(ИНН, 5, 1);
		ОбластьШапка.Параметры.ИНН6 = Сред(ИНН, 6, 1);
		ОбластьШапка.Параметры.ИНН7 = Сред(ИНН, 7, 1);
		ОбластьШапка.Параметры.ИНН8 = Сред(ИНН, 8, 1);
		ОбластьШапка.Параметры.ИНН9 = Сред(ИНН, 9, 1);
		ОбластьШапка.Параметры.ИНН10 = Сред(ИНН, 10, 1);
		ОбластьШапка.Параметры.ИНН11 = Сред(ИНН, 11, 1);
		ОбластьШапка.Параметры.ИНН12 = Сред(ИНН, 12, 1);
		ОбластьШапка.Параметры.ИНН13 = Сред(ИНН, 13, 1);
		ОбластьШапка.Параметры.ИНН14 = Сред(ИНН, 14, 1);
		
		ОбластьШапка.Параметры.НаименованиеНалоговой = Шапка.ОрганизацияГНС;
		
		ОбластьШапка.Параметры.ГНС1 = Сред(КодГНС, 1, 1);
		ОбластьШапка.Параметры.ГНС2 = Сред(КодГНС, 2, 1);
		ОбластьШапка.Параметры.ГНС3 = Сред(КодГНС, 3, 1);
		
		ОбластьШапка.Параметры.ДатаН1 = Сред(НачалоПериода, 1, 1);	
		ОбластьШапка.Параметры.ДатаН2 = Сред(НачалоПериода, 2, 1);	
		ОбластьШапка.Параметры.ДатаН3 = Сред(НачалоПериода, 4, 1);	
		ОбластьШапка.Параметры.ДатаН4 = Сред(НачалоПериода, 5, 1);	
		ОбластьШапка.Параметры.ДатаН5 = Сред(НачалоПериода, 7, 1);	
		ОбластьШапка.Параметры.ДатаН6 = Сред(НачалоПериода, 8, 1);	
		ОбластьШапка.Параметры.ДатаН7 = Сред(НачалоПериода, 9, 1);	
		ОбластьШапка.Параметры.ДатаН8 = Сред(НачалоПериода, 10, 1);	
		
		ОбластьШапка.Параметры.ДатаК1 = Сред(КонецПериода, 1, 1);	
		ОбластьШапка.Параметры.ДатаК2 = Сред(КонецПериода, 2, 1);	
		ОбластьШапка.Параметры.ДатаК3 = Сред(КонецПериода, 4, 1);	
		ОбластьШапка.Параметры.ДатаК4 = Сред(КонецПериода, 5, 1);	
		ОбластьШапка.Параметры.ДатаК5 = Сред(КонецПериода, 7, 1);	
		ОбластьШапка.Параметры.ДатаК6 = Сред(КонецПериода, 8, 1);	
		ОбластьШапка.Параметры.ДатаК7 = Сред(КонецПериода, 9, 1);	
		ОбластьШапка.Параметры.ДатаК8 = Сред(КонецПериода, 10, 1);
		
		ОбластьШапка.Параметры.Ячейка203 = Шапка.СуммаДоходов;
		ОбластьШапка.Параметры.Ячейка204 = Шапка.СуммаРасходов;
		
		СуммаЯчейка205 = ?(Шапка.СуммаДоходов - Шапка.СуммаРасходов > 0, Шапка.СуммаДоходов - Шапка.СуммаРасходов, 0);
		
		ОбластьШапка.Параметры.Ячейка205 = СуммаЯчейка205;
		ОбластьШапка.Параметры.Ячейка206 = Строка(Шапка.СтавкаНалогаНаПрибыль) + "%";
		
		СуммаЯчейка207 = ?(СуммаЯчейка205 > 0, СуммаЯчейка205 / 100 * Шапка.СтавкаНалогаНаПрибыль, 0);
		
		ОбластьШапка.Параметры.Ячейка207 = СуммаЯчейка207;
		ОбластьШапка.Параметры.Ячейка208 = 0;
		ОбластьШапка.Параметры.Ячейка209 = Строка(Шапка.СтавкаНалогаНаПрибыль) + "%";
		ОбластьШапка.Параметры.Ячейка210 = 0;
		ОбластьШапка.Параметры.Ячейка211 = СуммаЯчейка207;
		ОбластьШапка.Параметры.Ячейка212 = Шапка.СуммаНППредыдущийКвартал;
		
		СуммаЯчейка213 = СуммаЯчейка207 - Шапка.СуммаНППредыдущийКвартал;
		
		ОбластьШапка.Параметры.Ячейка213 = СуммаЯчейка213;
		ОбластьШапка.Параметры.Ячейка214 = ?(СуммаЯчейка213 < 0, -СуммаЯчейка213, 0);
		ОбластьШапка.Параметры.Ячейка215 = ?(СуммаЯчейка213 > 0, СуммаЯчейка213, 0);
		
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТекущийРасчетНалогаНаПрибыль") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"ТекущийРасчетНалогаНаПрибыль", 
		НСтр("ru = 'Текущий расчет налога на прибыль'"), 
		ПечатьНалогаНаПрибыль(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.ТекущийРасчетНалогаНаПрибыль.ПФ_MXL_ТекущийРасчетНалогаНаПрибыль");
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ТекущийРасчетНалогаНаПрибыль";
	КомандаПечати.Представление = НСтр("ru = 'Текущий расчет налога на прибыль'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция - ПолучитьКонтактнуюИнформацию
//
// Параметры:
//  Организация  - Спр.Ссылка - Спр.Организации 
// Возвращаемое значение:
//  Структура   - структура данных контактной информации
//
Функция ПолучитьКонтактнуюИнформацию(Организация)
	
	СведенияОбОрганизации = БухгалтерскийУчетСервер.ПолучитьСведенияОбОрганизации(Организация);

	Индекс = СведенияОбОрганизации.Индекс; 
	
	ГородНасПункт   = ?(СведенияОбОрганизации.Город  = "",СведенияОбОрганизации.НаселенныйПункт,СведенияОбОрганизации.Город);
	АдрОбластьГород = ?(СведенияОбОрганизации.Регион = "","",СведенияОбОрганизации.Регион + ",")
		+ ?(СведенияОбОрганизации.Район  = "","", " " + СведенияОбОрганизации.Район + ",") 
		+ ?(ГородНасПункт = "",""," " + ГородНасПункт); 
	АдресОрганизации = ?(СведенияОбОрганизации.Улица    = "","",СведенияОбОрганизации.Улица + ",")
		+ ?(СведенияОбОрганизации.Дом      = "",""," " + СведенияОбОрганизации.Дом + ",")
		+ ?(СведенияОбОрганизации.Корпус   = "",""," " + СведенияОбОрганизации.Корпус + ",")
		+ ?(СведенияОбОрганизации.Квартира = "",""," " + СведенияОбОрганизации.Квартира);
		
	Телефон = СведенияОбОрганизации.Тел;
	
	Структура = Новый Структура;
	Структура.Вставить("Индекс", Индекс);
	Структура.Вставить("АдрОбластьГород", АдрОбластьГород);
	Структура.Вставить("АдресОрганизации", АдресОрганизации);
	Структура.Вставить("Телефон", Телефон);
	
	Возврат Структура;
	
КонецФункции // ПолучитьАдресОрганизации()

#КонецОбласти

#КонецЕсли