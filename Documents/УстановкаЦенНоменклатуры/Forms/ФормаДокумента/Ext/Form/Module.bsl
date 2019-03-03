﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	// КопированиеСтрокТабличныхЧастей
	КопированиеТабличнойЧастиСервер.ПриСозданииНаСевере(Элементы, "Товары");
	// Конец КопированиеСтрокТабличныхЧастей
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = ПодключаемоеОборудованиеБППовтИсп.ИспользоватьПодключаемоеОборудование();
	Элементы.ЗапасыЗагрузитьДанныеИзТСД.Видимость = ИспользоватьПодключаемоеОборудование;
	// Конец ПодключаемоеОборудование
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.ДатыЗапретаИзменений
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменений
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом 
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
КонецПроцедуры

// Процедура - обработчик события ПриЗакрытии.
//
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ОбработанаТабличнаяЧастьТовары" И ТипЗнч(Параметр) = Тип("Структура") 
		И Параметр.Свойство("ИдентификаторВызывающейФормы")
		И Параметр.ИдентификаторВызывающейФормы = УникальныйИдентификатор Тогда
		ОбработкаОповещенияОбработкиТабличнойЧастиТоварыНаСервере(Параметр);
		
	ИначеЕсли ИмяСобытия = "ПодборНоменклатурыПроизведен" 
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресЗапасовВХранилище = Параметр;
		ПолучитьТоварыИзХранилища(АдресЗапасовВХранилище);
		
	ИначеЕсли ИмяСобытия = "ПодборДокументовПоступленияСДопРасходамиИГТД"
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		ЗаполнитьТабличнуюЧастьПоПоступлениюСГТДНаСервере(Параметр)
	КонецЕсли;
	
	// КопированиеСтрокТабличныхЧастей
	Если ИмяСобытия = "БуферОбменаТабличнаяЧастьКопированиеСтрок" Тогда
		КопированиеТабличнойЧастиКлиент.ОбработкаОповещения(Элементы, "Товары");
	КонецЕсли;
	// Конец КопированиеСтрокТабличныхЧастей
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование"
		И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			// Преобразуем предварительно к ожидаемому формату.
			Если Параметр[1] = Неопределено Тогда
				ТекШтрихкод = Параметр[0]; // Достаем штрихкод из основных данных
			Иначе
				ТекШтрихкод = Параметр[1][1]; // Достаем штрихкод из дополнительных данных
			КонецЕсли;
			
			ПоискПоШтрихкодуЗавершение(ТекШтрихкод, Новый Структура("ТекШтрихкод, ИмяТабличнойЧасти", ТекШтрихкод, "Товары"));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Объект.Номер = "";

	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда 
		Валюта = ВалютаТипаЦен(Объект.ТипЦен);

		СтрокаТабличнойЧасти = Элемент.ТекущиеДанные;
		СтрокаТабличнойЧасти.Валюта = ?(ЗначениеЗаполнено(Валюта), Валюта, ВалютаРегламентированногоУчета);
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ЗаполнитьПоНоменклатуре(Команда)
	
	ЗаполнитьТабличнуюЧасть(Истина, Ложь, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоЦенамНоменклатуры(Команда)
	
	ЗаполнитьТабличнуюЧасть(Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоЦенамНоменклатуры(Команда)
	
	ЗаполнитьТабличнуюЧасть(Ложь, Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПоЦенамНоменклатуры(Команда)
	
	ЗаполнитьТабличнуюЧасть(Ложь, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПоступлению(Команда)
	
	Если Объект.Товары.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьПоПоступлению", ЭтотОбъект, Параметры);
		ТекстВопроса = НСтр("ru = 'Перед заполнением табличная часть будет очищена. Заполнить?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ОткрытьФормуВыбораПоступления();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоПоступлению(Команда)
	
	// Выбираем документ, по которому будем заполнять
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ЗаполнитьПоПоступлениюЗавершение", ЭтотОбъект);	
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.Форма.ФормаВыбора",,,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПоступлениюСГТД(Команда)
	
	Если Объект.Товары.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьПоступлениюСГТД", ЭтотОбъект, Параметры);
		ТекстВопроса = НСтр("ru = 'Перед заполнением табличная часть будет очищена. Заполнить?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ОткрытьФормуВыбораПоступленияСДопРаходамиИГТД();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоПоступлениюСГТД(Команда)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("УникальныйИдентификаторФормыВладельца", УникальныйИдентификатор);
		
	ОткрытьФорму("Документ.УстановкаЦенНоменклатуры.Форма.ФормаПодбораПоступленийСДопрасходамиИГТД", ПараметрыОтбора);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстатками(Команда)
	Если Объект.Товары.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьОстатками", ЭтотОбъект, Параметры);
		ТекстВопроса = НСтр("ru = 'Перед заполнением табличная часть будет очищена. Заполнить?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьТабличнуюЧастьОстаткамиНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	
	ПараметрыФормы = ПолучитьПараметрыОбработкиТабличнойЧастиТовары();
	Если ПараметрыФормы <> Неопределено Тогда
		ОткрытьФорму("Обработка.ИзменениеЦенНоменклатуры.Форма.Форма", ПараметрыФормы,
			ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события действия команды Подбор в табличную часть Товары.
// Открывает форму подбора.
//
&НаКлиенте
Процедура ПодборНоменклатуры(Команда)
	Если НЕ ЗначениеЗаполнено(Объект.ТипЦен) Тогда
		ТекстСообщения = НСтр("ru = 'Не выбран тип цен номенклатуры'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ТипЦен");
		Возврат;
	КонецЕсли;
	
	РаботаСПодборомНоменклатурыКлиент.ОткрытьПодбор(ЭтаФорма, "Товары", "УстановкаЦен");
КонецПроцедуры

// ПодключаемоеОборудование
&НаКлиенте
Процедура ПоискПоШтрихкодуТовары(Команда)
	
	ТекШтрихкод = "";
	ПоказатьВводЗначения(Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", 
		ЭтотОбъект, Новый Структура("ТекШтрихкод, ИмяТабличнойЧасти", ТекШтрихкод, "Товары")), ТекШтрихкод, НСтр("ru = 'Введите штрихкод'"));
		
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ТекШтрихкод = ?(Результат = Неопределено, ДополнительныеПараметры.ТекШтрихкод, Результат);
    
	Если НЕ ПустаяСтрока(ТекШтрихкод) Тогда
        ПолученыШтрихкоды(Новый Структура("Штрихкод, Количество", ТекШтрихкод, 1), ДополнительныеПараметры.ИмяТабличнойЧасти);
	КонецЕсли;	

КонецПроцедуры 

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	ПодключаемоеОборудованиеБПКлиент.ПолучитьДанныеИзТСД(ЭтотОбъект, "Товары");
КонецПроцедуры // ЗагрузитьДанныеИзТСД()
// Конец ПодключаемоеОборудование

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧасть(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.Товары.Очистить();
		ЗаполнитьТабличнуюЧастьНаСервере(ДополнительныеПараметры.Очистить, ДополнительныеПараметры.Обновить, ДополнительныеПараметры.ПоНоменклатуре);
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьПоПоступлению(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Товары.Очистить();
		ОткрытьФормуВыбораПоступления();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьПоступлениюСГТД(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Товары.Очистить();
		ОткрытьФормуВыбораПоступленияСДопРаходамиИГТД();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПоступлениюЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ДокументПоступление = РезультатЗакрытия;
	
	Если НЕ ЗначениеЗаполнено(ДокументПоступление) Тогда 
		Возврат; // ничего не выбрали.
	КонецЕсли;

	ЗаполнитьТабличнуюЧастьПоПоступлениюНаСервере(ДокументПоступление);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьОстатками(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьТабличнуюЧастьОстаткамиНаСервере();
	КонецЕсли; 
КонецПроцедуры

#КонецОбласти

#Область КопированиеСтрокТабличныхЧастей

&НаКлиенте
Процедура ТоварыКопироватьСтроки(Команда)
	
	КопироватьСтроки("Товары");
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВставитьСтроки(Команда)
	
	ВставитьСтроки("Товары");
	
КонецПроцедуры

&НаКлиенте
Процедура КопироватьСтроки(ИмяТЧ)
	
	Если КопированиеТабличнойЧастиКлиент.МожноКопироватьСтроки(Объект[ИмяТЧ], Элементы[ИмяТЧ].ТекущиеДанные) Тогда
		КоличествоСкопированных = 0;
		КопироватьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных);
		КопированиеТабличнойЧастиКлиент.ОповеститьПользователяОКопированииСтрок(КоличествоСкопированных);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(ИмяТЧ)
	
	КоличествоСкопированных = 0;
	КоличествоВставленных = 0;
	ВставитьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных, КоличествоВставленных);
	КопированиеТабличнойЧастиКлиент.ОповеститьПользователяОВставкеСтрок(КоличествоСкопированных, КоличествоВставленных);
	
КонецПроцедуры

&НаСервере
Процедура КопироватьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных)
	
	КопированиеТабличнойЧастиСервер.Копировать(Объект[ИмяТЧ], Элементы[ИмяТЧ].ВыделенныеСтроки, КоличествоСкопированных);
	
КонецПроцедуры

&НаСервере
Процедура ВставитьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных, КоличествоВставленных)
	
	КопированиеТабличнойЧастиСервер.Вставить(Объект, ИмяТЧ, Элементы, КоличествоСкопированных, КоличествоВставленных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Процедура - Заполнить табличную часть
// Параметры:
//  Очистить		 - Булево - Очистить и перезаполнить табличную часть  
//  Обновить		 - Булево - Обновить цены по номенклатуре в табличной части, не добавляя новые строки. Если Ложь, то добавляем новые.  
//  ПоНоменклатуре	 - Булево - Заполняем из справочника Номенклатура без отбора по Типу цен. Если ложь, то ищем из спр. по выранному типу цен.
//
&НаКлиенте
Процедура ЗаполнитьТабличнуюЧасть(Очистить, Обновить, ПоНоменклатуре = Ложь)
	
	Если НЕ ЗначениеЗаполнено(Объект.ТипЦен) Тогда
		ТекстСообщения = НСтр("ru = 'Не выбран тип цен номенклатуры'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ТипЦен");
		Возврат;
	КонецЕсли;

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Очистить", Очистить);
	ДополнительныеПараметры.Вставить("Обновить", Обновить);
	ДополнительныеПараметры.Вставить("ПоНоменклатуре", ПоНоменклатуре);

	Если Объект.Товары.Количество() > 0 И Очистить Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧасть", ЭтотОбъект, ДополнительныеПараметры);
		ТекстВопроса = НСтр("ru = 'Перед заполнением табличная часть будет очищена. Заполнить?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);		
	Иначе
		ЗаполнитьТабличнуюЧастьНаСервере(Очистить, Обновить, ПоНоменклатуре);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - Заполнить табличную часть на сервере
//
&НаСервере
Процедура ЗаполнитьТабличнуюЧастьНаСервере(Очистить, Обновить, ПоНоменклатуре)
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьТабличнуюЧасть(Очистить, Обновить, ПоНоменклатуре);
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры // ЗаполнитьТабличнуюЧастьНаСервере()

&НаКлиенте
Процедура ОткрытьФормуВыбораПоступления()
	
	// Выбираем документ, по которому будем заполнять
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ЗаполнитьПоПоступлениюЗавершение", ЭтотОбъект);	
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.Форма.ФормаВыбора",,,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораПоступленияСДопРаходамиИГТД()
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("УникальныйИдентификаторФормыВладельца", УникальныйИдентификатор);
		
	ОткрытьФорму("Документ.УстановкаЦенНоменклатуры.Форма.ФормаПодбораПоступленийСДопрасходамиИГТД", ПараметрыОтбора);	
КонецПроцедуры

// Процедура - Заполнить табличную часть по поступлению на сервере
//
&НаСервере
Процедура ЗаполнитьТабличнуюЧастьПоПоступлениюНаСервере(ДокументПоступление)
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьТабличнуюЧастьПоПоступлению(ДокументПоступление);
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры // ЗаполнитьТабличнуюЧастьПоПоступлениюНаСервере()

// Процедура - Заполнить табличную часть по поступлению С ГТД на сервере
//
&НаСервере
Процедура ЗаполнитьТабличнуюЧастьПоПоступлениюСГТДНаСервере(МассивДокументов)
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьТабличнуюЧастьПоПоступлениюСГТД(МассивДокументов);
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры // ЗаполнитьТабличнуюЧастьПоПоступлениюСГТДНаСервере()

// Процедура - Заполнить табличную часть остатками на сервере
//
&НаСервере
Процедура ЗаполнитьТабличнуюЧастьОстаткамиНаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьТабличнуюЧастьОстатками();
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры // ЗаполнитьТабличнуюЧастьОстаткамиНаСервере()

&НаКлиенте
Функция ПолучитьПараметрыОбработкиТабличнойЧастиТовары()
	
	ПараметрыОбработки = Новый Структура;
	
	ПараметрыОбработки.Вставить("АдресХранилищаТовары", ПоместитьТоварыВоВременноеХранилищеНаСервере());
	ПараметрыОбработки.Вставить("Заголовок",            НСтр("ru = 'ТМЗ и услуги'"));
	ПараметрыОбработки.Вставить("ДокументСсылка", 		Объект.Ссылка);
	ПараметрыОбработки.Вставить("ДокументДата", 		Объект.Дата);
	ПараметрыОбработки.Вставить("ДокументОрганизация", 	Объект.Организация);
	ПараметрыОбработки.Вставить("ДокументТипЦен", 		Объект.ТипЦен);	

	Возврат ПараметрыОбработки;
	
КонецФункции

&НаСервере
Функция ПоместитьТоварыВоВременноеХранилищеНаСервере()

	Возврат ПоместитьВоВременноеХранилище(Объект.Товары.Выгрузить(), УникальныйИдентификатор);

КонецФункции

&НаСервере
Процедура ОбработкаОповещенияОбработкиТабличнойЧастиТоварыНаСервере(Параметры)

	ТаблицаОбработки = ПолучитьИзВременногоХранилища(Параметры.АдресОбработаннойТабличнойЧастиТоварыВХранилище);
	
	Объект.Товары.Загрузить(ТаблицаОбработки);
		
КонецПроцедуры

// Процедура - обработчик подбора товаров.
//
&НаСервере
Процедура ПолучитьТоварыИзХранилища(АдресЗапасовВХранилище)
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	Для Каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		НайденныеСтроки = Объект.Товары.НайтиСтроки(Новый Структура("Номенклатура", СтрокаЗагрузки.Номенклатура));
		
		Если НайденныеСтроки.Количество() > 0 Тогда 
			Продолжить;
		КонецЕсли;	
		
		СтрокаТабличнойЧасти = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаЗагрузки);
		СтрокаТабличнойЧасти.Валюта = ?(ЗначениеЗаполнено(Объект.ТипЦен.ВалютаЦены), Объект.ТипЦен.ВалютаЦены, ВалютаРегламентированногоУчета);
	КонецЦикла;
		
КонецПроцедуры // ПолучитьТоварыИзХранилища()

&НаСервереБезКонтекста
Функция ВалютаТипаЦен(ТипЦен)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТипЦен, "ВалютаЦены");
КонецФункции // ВалютаТипаЦен()

// ПодключаемоеОборудование

// Процедура - Получены штрихкоды
//
// Параметры:
//  ДанныеШтрикодов	 - Структура/Массив - В зависимости от точки вызова передается структура (обработка сканера) или массив (обработка ТСД)
//  ИмяТабличнойЧасти	 - Строка	 - Имя табличной части для загрузки
//
&НаКлиенте
Процедура ПолученыШтрихкоды(ДанныеШтрикодов, ИмяТабличнойЧасти) Экспорт
	
	Модифицированность = Истина;
	
	НедобавленныеШтрихкоды = ЗаполнитьПоДаннымШтрихкодов(ДанныеШтрикодов, ИмяТабличнойЧасти);
	
	// Неизвестные штрихкоды.
	Если НедобавленныеШтрихкоды.НеизвестныеШтрихкоды.Количество() > 0 Тогда
		Для Каждого СтруктураДанные Из НедобавленныеШтрихкоды.НеизвестныеШтрихкоды Цикл 
			СтрокаСообщения = СтрШаблон(НСтр("ru = 'Данные по штрихкоду не найдены: %1'"), СтруктураДанные.Штрихкод);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);
		КонецЦикла;	
	// Штрихкоды некорректного типа.
	ИначеЕсли НедобавленныеШтрихкоды.ШтрихкодыНекорректногоТипа.Количество() > 0 Тогда 
		Для Каждого СтруктураДанные Из НедобавленныеШтрихкоды.ШтрихкодыНекорректногоТипа Цикл 
			СтрокаСообщения = СтрШаблон(НСтр("ru = 'Найденная по штрихкоду %1 номенклатура: ""%2"", не подходит для этой табличной части'"),
				СтруктураДанные.ТекШтрихкод, СтруктураДанные.Номенклатура);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);
		КонецЦикла;	
	КонецЕсли;	
	
КонецПроцедуры // ПолученыШтрихкоды()

&НаСервереБезКонтекста
Функция ПолучитьДанныеПоШтрихкоду(ТекШтрихкод)
	
	Номенклатура = РегистрыСведений.ШтрихкодыНоменклатуры.ПолучитьНоменклатуруПоШтрихкоду(ТекШтрихкод);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("Номенклатура", Номенклатура);
	СтруктураДанные.Вставить("ТипНоменклатурыУслуга", ?(ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура"), Номенклатура.Услуга, Ложь));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеПоШтрихкоду()

// Функция - Заполнить по данным штрихкодов
//
// Параметры:
//  ДанныеШтрикодов		 - 	 - Структура/Массив	 - В зависимости от точки вызова передается структура (обработка сканера) или массив (обработка ТСД)
//  ИмяТабличнойЧасти	 - Строка	 - Имя табличной части для загрузки
// 
// Возвращаемое значение:
//  Структура - Массивы неизвестных штрих кодов
//
&НаКлиенте
Функция ЗаполнитьПоДаннымШтрихкодов(ДанныеШтрикодов, ИмяТабличнойЧасти) 
	
	НеизвестныеШтрихкоды = Новый Массив;
	ШтрихкодыНекорректногоТипа = Новый Массив;
	
	Если ТипЗнч(ДанныеШтрикодов) = Тип("Массив") Тогда
		МассивШтрихкодов = ДанныеШтрикодов;
	Иначе
		МассивШтрихкодов = Новый Массив;
		МассивШтрихкодов.Добавить(ДанныеШтрикодов);
	КонецЕсли;
	
	Для каждого ТекШтрихкод Из МассивШтрихкодов Цикл
		СтруктураДанные = ПолучитьДанныеПоШтрихкоду(ТекШтрихкод);
		
		Если НЕ ЗначениеЗаполнено(СтруктураДанные.Номенклатура) Тогда 
			НеизвестныеШтрихкоды.Добавить(ТекШтрихкод);
		ИначеЕсли СтруктураДанные.ТипНоменклатурыУслуга Тогда
			ШтрихкодыНекорректногоТипа.Добавить(Новый Структура("ТекШтрихкод, Номенклатура", ТекШтрихкод, СтруктураДанные.Номенклатура));
		Иначе 
			СтрокаТабличнойЧасти = Объект[ИмяТабличнойЧасти].Добавить();
			СтрокаТабличнойЧасти.Номенклатура = СтруктураДанные.Номенклатура;
			СтрокаТабличнойЧасти.Количество = ТекШтрихкод.Количество;
		КонецЕсли;
	КонецЦикла;	
	
	Возврат Новый Структура("НеизвестныеШтрихкоды, ШтрихкодыНекорректногоТипа",
		НеизвестныеШтрихкоды, ШтрихкодыНекорректногоТипа);

КонецФункции // ЗаполнитьПоДаннымШтрихкодов()
// Конец ПодключаемоеОборудование

#КонецОбласти
