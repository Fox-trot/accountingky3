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
	
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
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
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
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
	ПересчитатьИтоговыеСуммы();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
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
	Если ИмяСобытия = "ПодборНоменклатурыПроизведен" 
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресЗапасовВХранилище = Параметр;
		ПолучитьТоварыИзХранилища(АдресЗапасовВХранилище);
	КонецЕсли;
	
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
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("УстановитьПиктограммуКомментария", 0.1, Истина);
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

// Процедура - обработчик события ПриИзменении поля ввода Товары.
//
&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	ПересчитатьИтоговыеСуммы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Количество.
//
&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	СтрокаТабличнойЧасти.Отклонение = СтрокаТабличнойЧасти.Количество - СтрокаТабличнойЧасти.УчетноеКоличество;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыМБП

// Процедура - обработчик события ПриИзменении поля ввода МБПКоличество.
//
&НаКлиенте
Процедура МБПКоличествоПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.МБП.ТекущиеДанные;
	СтрокаТабличнойЧасти.Отклонение = СтрокаТабличнойЧасти.Количество - СтрокаТабличнойЧасти.УчетноеКоличество;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода МБП.
//
&НаКлиенте
Процедура МБППриИзменении(Элемент)
	ПересчитатьИтоговыеСуммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьТовары(Команда)
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Склад) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнен склад! Заполнение документа отменено.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.Склад",,Отказ)		
	КонецЕсли;

	Если Отказ Тогда 
		Возврат
	КонецЕсли;		
	
	Если Объект.Товары.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧастьТовары", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);	
	Иначе
		ЗаполнитьТоварыНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбнулитьТоварыФактическоеКоличество(Команда)
	Если Объект.Товары.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросОбнулитьФактическоеКоличествоТовары", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Хотите обнулить фактическое количество?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьТоварыУчетныеКоличестваИСуммы(Команда)
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Склад) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнен склад! Заполнение документа отменено.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.Склад",,Отказ)		
	КонецЕсли;

	Если Отказ Тогда 
		Возврат
	КонецЕсли;		
	
	Если Объект.Товары.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросПерезаполнитьТоварыУчетныеКоличестваИСуммы", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Учетные количества и суммы будут перезаполнены! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьМБП(Команда)
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Склад) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнен склад! Заполнение документа отменено.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.Склад",,Отказ)		
	КонецЕсли;

	Если Отказ Тогда 
		Возврат
	КонецЕсли;		
	
	Если Объект.МБП.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧастьМБП", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);	
	Иначе
		ЗаполнитьМБПНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбнулитьМБПФактическоеКоличество(Команда)
	Если Объект.МБП.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросОбнулитьФактическоеКоличествоМБП", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Хотите обнулить фактическое количество?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьМБПУчетныеКоличестваИСуммы(Команда)
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Склад) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнен склад! Заполнение документа отменено.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.Склад",,Отказ)		
	КонецЕсли;

	Если Отказ Тогда 
		Возврат
	КонецЕсли;		
	
	Если Объект.МБП.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросПерезаполнитьМБПУчетныеКоличестваИСуммы", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Учетные количества и суммы будут перезаполнены! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);	
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события действия команды Подбор в табличную часть Товары.
// Открывает форму подбора.
//
&НаКлиенте
Процедура ПодборНоменклатуры(Команда)
	РаботаСПодборомНоменклатурыКлиент.ОткрытьПодбор(ЭтаФорма, "Товары", "Списание");
КонецПроцедуры

// ПодключаемоеОборудование
&НаКлиенте
Процедура ПоискПоШтрихкодуТовары(Команда)
	
	ТекШтрихкод = "";
	ПоказатьВводЗначения(Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", 
		ЭтотОбъект, Новый Структура("ТекШтрихкод, ИмяТабличнойЧасти", ТекШтрихкод, "Товары")), ТекШтрихкод, НСтр("ru = 'Введите штрихкод'"));
		
КонецПроцедуры
	
&НаКлиенте
Процедура ПоискПоШтрихкодуМБП(Команда)
	
	ТекШтрихкод = "";
	ПоказатьВводЗначения(Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", 
		ЭтотОбъект, Новый Структура("ТекШтрихкод, ИмяТабличнойЧасти", ТекШтрихкод, "МБП")), ТекШтрихкод, НСтр("ru = 'Введите штрихкод'"));
		
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

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСДМБП(Команда)
	ПодключаемоеОборудованиеБПКлиент.ПолучитьДанныеИзТСД(ЭтотОбъект, "МБП");
КонецПроцедуры // ЗагрузитьДанныеИзТСД()

// Конец ПодключаемоеОборудование

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧастьТовары(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.Товары.Очистить();
		ЗаполнитьТоварыНаСервере();
    КонецЕсли;
КонецПроцедуры //

&НаКлиенте
Процедура ОтветНаВопросОбнулитьФактическоеКоличествоТовары(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОбнулитьФактическоеКоличествоТовары();
    КонецЕсли;
КонецПроцедуры //

&НаКлиенте
Процедура ОтветНаВопросПерезаполнитьТоварыУчетныеКоличестваИСуммы(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПерезаполнитьТоварыУчетныеКоличестваИСуммыНаСервере();
    КонецЕсли;
КонецПроцедуры //

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧастьМБП(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.МБП.Очистить();
		ЗаполнитьМБПНаСервере();
    КонецЕсли;
КонецПроцедуры //

&НаКлиенте
Процедура ОтветНаВопросОбнулитьФактическоеКоличествоМБП(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОбнулитьФактическоеКоличествоМБП();
    КонецЕсли;
КонецПроцедуры //

&НаКлиенте
Процедура ОтветНаВопросПерезаполнитьМБПУчетныеКоличестваИСуммы(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПерезаполнитьМБПУчетныеКоличестваИСуммыНаСервере();
    КонецЕсли;
КонецПроцедуры //

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

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТоварыНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Хозрасчетный.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ СписокСчетов
		|ИЗ
		|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
		|ГДЕ
		|	Хозрасчетный.ВидыСубконто.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Субконто1 КАК Номенклатура,
		|	ХозрасчетныйОстатки.Субконто2 КАК Склад,
		|	ХозрасчетныйОстатки.СуммаОстаток КАК УчетнаяСумма,
		|	ХозрасчетныйОстатки.КоличествоОстаток КАК УчетноеКоличество,
		|	ХозрасчетныйОстатки.КоличествоОстаток КАК Количество,
		|	ВЫБОР
		|		КОГДА ХозрасчетныйОстатки.КоличествоОстаток <> 0
		|			ТОГДА ХозрасчетныйОстатки.СуммаОстаток / ХозрасчетныйОстатки.КоличествоОстаток
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Цена,
		|	ХозрасчетныйОстатки.Счет КАК СчетУчета,
		|	ХозрасчетныйОстатки.СуммаОстаток КАК Сумма
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Период,
		|			Счет В
		|				(ВЫБРАТЬ
		|					СписокСчетов.Ссылка
		|				ИЗ
		|					СписокСчетов КАК СписокСчетов),
		|			&ВидыСубконто,
		|			Организация = &Организация
		|				И Субконто2 = &Склад) КАК ХозрасчетныйОстатки";
	Запрос.УстановитьПараметр("Период", ДатаДокумента);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	
	ВидыСубконто = Новый Массив();
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	Запрос.УстановитьПараметр("ВидыСубконто", ВидыСубконто);
	
	Объект.Товары.Загрузить(Запрос.Выполнить().Выгрузить());	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьТоварыУчетныеКоличестваИСуммыНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Товары.Номенклатура КАК Номенклатура,
		|	Товары.Отклонение КАК Отклонение,
		|	Товары.Количество КАК Количество,
		|	Товары.Сумма КАК Сумма,
		|	Товары.СчетУчета КАК СчетУчета
		|ПОМЕСТИТЬ ВременнаяТаблицаТовары
		|ИЗ
		|	&Товары КАК Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаТовары.Номенклатура КАК Номенклатура,
		|	ХозрасчетныйОстатки.Субконто2 КАК Склад,
		|	ВременнаяТаблицаТовары.Количество КАК Количество,
		|	ВременнаяТаблицаТовары.Сумма КАК Сумма,
		|	ЕСТЬNULL(ХозрасчетныйОстатки.КоличествоОстаток, 0) КАК УчетноеКоличество,
		|	ЕСТЬNULL(ХозрасчетныйОстатки.СуммаОстаток, 0) КАК УчетнаяСумма,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ХозрасчетныйОстатки.КоличествоОстаток, 0) <> 0
		|			ТОГДА ХозрасчетныйОстатки.СуммаОстаток / ЕСТЬNULL(ХозрасчетныйОстатки.КоличествоОстаток, 0)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Цена,
		|	ХозрасчетныйОстатки.Счет КАК СчетУчета,
		|	ВременнаяТаблицаТовары.Количество - ЕСТЬNULL(ХозрасчетныйОстатки.КоличествоОстаток, 0) КАК Отклонение
		|ИЗ
		|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
		|				&Период,
		|				Счет В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ВременнаяТаблицаТовары.СчетУчета
		|					ИЗ
		|						ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары),
		|				&ВидыСубконто,
		|				Организация = &Организация
		|					И Субконто2 = &Склад
		|					И Субконто1 В
		|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|							ВременнаяТаблицаТовары.Номенклатура
		|						ИЗ
		|							ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары)) КАК ХозрасчетныйОстатки
		|		ПО ВременнаяТаблицаТовары.Номенклатура = ХозрасчетныйОстатки.Субконто1
		|			И ВременнаяТаблицаТовары.СчетУчета = ХозрасчетныйОстатки.Счет";
	Запрос.УстановитьПараметр("Товары", Объект.Товары.Выгрузить());
	Запрос.УстановитьПараметр("Период", ДатаДокумента);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	
	ВидыСубконто = Новый Массив();
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	Запрос.УстановитьПараметр("ВидыСубконто", 		ВидыСубконто);
	
	Объект.Товары.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьМБПНаСервере() 	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Субконто1 КАК Номенклатура,
		|	ХозрасчетныйОстатки.Субконто2 КАК Склад,
		|	ХозрасчетныйОстатки.СуммаОстаток КАК УчетнаяСумма,
		|	ХозрасчетныйОстатки.КоличествоОстаток КАК УчетноеКоличество,
		|	ХозрасчетныйОстатки.СуммаОстаток КАК Сумма,	
		|	ХозрасчетныйОстатки.КоличествоОстаток КАК Количество,
		|	ВЫБОР
		|		КОГДА ХозрасчетныйОстатки.КоличествоОстаток <> 0
		|			ТОГДА ХозрасчетныйОстатки.СуммаОстаток / ХозрасчетныйОстатки.КоличествоОстаток
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Цена
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Период,
		|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МБП),
		|			&ВидыСубконто,
		|			Организация = &Организация
		|				И (ВЫРАЗИТЬ(Субконто2 КАК Справочник.Склады)) = &Склад) КАК ХозрасчетныйОстатки";
	Запрос.УстановитьПараметр("Период", ДатаДокумента);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	
	ВидыСубконто = Новый Массив();
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Местонахождение);
	Запрос.УстановитьПараметр("ВидыСубконто", ВидыСубконто);
	
	Объект.МБП.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьМБПУчетныеКоличестваИСуммыНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МБП.Номенклатура КАК Номенклатура,
		|	МБП.Количество КАК Количество,
		|	МБП.Сумма КАК Сумма
		|ПОМЕСТИТЬ ВременнаяТаблицаМБП
		|ИЗ
		|	&МБП КАК МБП
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Субконто1 КАК Номенклатура,
		|	ХозрасчетныйОстатки.Субконто2 КАК Склад,
		|	ВременнаяТаблицаМБП.Количество КАК Количество,
		|	ВременнаяТаблицаМБП.Сумма КАК Сумма,
		|	ЕСТЬNULL(ХозрасчетныйОстатки.КоличествоОстаток, 0) КАК УчетноеКоличество,
		|	ЕСТЬNULL(ХозрасчетныйОстатки.СуммаОстаток, 0) КАК УчетнаяСумма,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ХозрасчетныйОстатки.КоличествоОстаток, 0) <> 0
		|			ТОГДА ЕСТЬNULL(ХозрасчетныйОстатки.СуммаОстаток, 0) / ЕСТЬNULL(ХозрасчетныйОстатки.КоличествоОстаток, 0)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Цена,
		|	ВременнаяТаблицаМБП.Количество - ЕСТЬNULL(ХозрасчетныйОстатки.КоличествоОстаток, 0) КАК Отклонение
		|ИЗ
		|	ВременнаяТаблицаМБП КАК ВременнаяТаблицаМБП
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
		|				&Период,
		|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МБП),
		|				&ВидыСубконто,
		|				Организация = &Организация
		|					И Субконто2 = &Склад
		|					И Субконто1 В
		|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|							ВременнаяТаблицаМБП.Номенклатура
		|						ИЗ
		|							ВременнаяТаблицаМБП КАК ВременнаяТаблицаМБП)) КАК ХозрасчетныйОстатки
		|		ПО ВременнаяТаблицаМБП.Номенклатура = ХозрасчетныйОстатки.Субконто1";
	Запрос.УстановитьПараметр("МБП", Объект.МБП.Выгрузить());
	Запрос.УстановитьПараметр("Период", ДатаДокумента);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	
	ВидыСубконто = Новый Массив();
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Местонахождение);
	Запрос.УстановитьПараметр("ВидыСубконто", ВидыСубконто);
	
	Объект.МБП.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьИтоговыеСуммы()

	СуммаИтого 			= Объект.Товары.Итог("Сумма") 			+ Объект.МБП.Итог("Сумма");	
	УчетнаяСуммаИтого 	= Объект.Товары.Итог("УчетнаяСумма") 	+ Объект.МБП.Итог("УчетнаяСумма");

КонецПроцедуры // ПересчитатьИтоговыеСуммы()

&НаКлиенте
Процедура ОбнулитьФактическоеКоличествоТовары()
	Для Каждого СтрокаТабличнойЧасти Из Объект.Товары Цикл 
		СтрокаТабличнойЧасти.Количество = 0;
		СтрокаТабличнойЧасти.Сумма = 0;
	КонецЦикла;	
КонецПроцедуры //

&НаКлиенте
Процедура ОбнулитьФактическоеКоличествоМБП()
	Для Каждого СтрокаТабличнойЧасти Из Объект.МБП Цикл 
		СтрокаТабличнойЧасти.Количество = 0;
		СтрокаТабличнойЧасти.Сумма = 0;		
	КонецЦикла;	
КонецПроцедуры //

// Процедура - обработчик подбора товаров.
//
&НаСервере
Процедура ПолучитьТоварыИзХранилища(АдресЗапасовВХранилище)
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	Для Каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		НайденныеСтроки = Объект.Товары.НайтиСтроки(Новый Структура("Номенклатура, СчетУчета", СтрокаЗагрузки.Номенклатура, СтрокаЗагрузки.СчетУчета));
		
		Если НайденныеСтроки.Количество() > 0 Тогда 
			Продолжить;
		КонецЕсли;	
		
		СтрокаТабличнойЧасти = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаЗагрузки);
	КонецЦикла;
		
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

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
			ОбщегоНазначенияКлиент.СообщитьПользователю(СтрокаСообщения);
		КонецЦикла;	
	// Штрихкоды некорректного типа.
	ИначеЕсли НедобавленныеШтрихкоды.ШтрихкодыНекорректногоТипа.Количество() > 0 Тогда 
		Для Каждого СтруктураДанные Из НедобавленныеШтрихкоды.ШтрихкодыНекорректногоТипа Цикл 
			СтрокаСообщения = СтрШаблон(НСтр("ru = 'Найденная по штрихкоду %1 номенклатура: ""%2"", не подходит для этой табличной части'"),
				СтруктураДанные.ТекШтрихкод, СтруктураДанные.Номенклатура);
			ОбщегоНазначенияКлиент.СообщитьПользователю(СтрокаСообщения);
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

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ПроцедурыИФункцииКомиссия

// Процедура - обработчик события команды ПодборФизическихЛиц.
// Открывает форму выбора.
//
&НаКлиенте
Процедура ПодборФизическихЛиц(Команда)

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаВыбора", ПараметрыФормы, Элементы.Комиссия);

КонецПроцедуры

// Процедура - обработчик события ПередУдалением таблицы Комиссия.
//
&НаКлиенте
Процедура КомиссияПередУдалением(Элемент, Отказ)

	ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;
	Если ТекущаяСтрокаТЧ.Председатель Тогда
		ИндексУдаляемойСтроки = Объект.Комиссия.Индекс(ТекущаяСтрокаТЧ);
		КоличествоСтрок = Объект.Комиссия.Количество() - 1;

		Если КоличествоСтрок > 0 Тогда
			Если ИндексУдаляемойСтроки <= КоличествоСтрок - 1 Тогда
				ИндексНовогоПредседателя = ИндексУдаляемойСтроки + 1;
			Иначе
				ИндексНовогоПредседателя = КоличествоСтрок - 1;
			КонецЕсли;
			Объект.Комиссия[ИндексНовогоПредседателя].Председатель = Истина;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ПриНачалеРедактирования таблицы Комиссия.
//
&НаКлиенте
Процедура КомиссияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если Копирование Тогда
		ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;
		ТекущаяСтрокаТЧ.ФизЛицо = Неопределено;
		ТекущаяСтрокаТЧ.Председатель = Ложь;
	Иначе // Создание заново
		Если Объект.Комиссия.Количество() = 1 Тогда
			Объект.Комиссия[0].Председатель = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ОбработкаВыбора таблицы Комиссия.
//
&НаКлиенте
Процедура КомиссияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Строки = Объект.Комиссия.НайтиСтроки(Новый Структура("ФизЛицо", ВыбранноеЗначение));

	Если Строки.Количество() > 0 Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Физическое лицо ""%1"" уже подобрано!'"), ВыбранноеЗначение);
		ПоказатьПредупреждение(, ТекстСообщения, 60);
	Иначе
		НоваяСтрока = Объект.Комиссия.Добавить();
		НоваяСтрока.ФизЛицо = ВыбранноеЗначение;
		Если Объект.Комиссия.Количество() = 1 Тогда
			НоваяСтрока.Председатель = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Председатель.
//
&НаКлиенте
Процедура КомиссияПредседательПриИзменении(Элемент)

	ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;

	Если НЕ ТекущаяСтрокаТЧ.Председатель Тогда
		// Снимать флажок нельзя
		ТекущаяСтрокаТЧ.Председатель = Истина;
		Возврат;
	КонецЕсли;

	Для каждого СтрокаТЧ Из Объект.Комиссия Цикл
		Если СтрокаТЧ.НомерСтроки <> ТекущаяСтрокаТЧ.НомерСтроки Тогда
			СтрокаТЧ.Председатель = Ложь;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ФизЛицо.
//
&НаКлиенте
Процедура КомиссияФизЛицоПриИзменении(Элемент)

	Если Объект.Комиссия.Количество() = 1 Тогда
		Объект.Комиссия[0].Председатель = Истина;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ОбработкаВыбора поля ввода ФизЛицо.
//
&НаКлиенте
Процедура КомиссияФизЛицоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;

	Если ТекущаяСтрокаТЧ.ФизЛицо <> ВыбранноеЗначение Тогда

		СтрокиТабличнойЧасти = Объект.Комиссия.НайтиСтроки(Новый Структура("ФизЛицо", ВыбранноеЗначение));

		Если СтрокиТабличнойЧасти.Количество() > 0 Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Физическое лицо ""%1"" уже включено в состав комиссии!'"), ВыбранноеЗначение);
			ПоказатьПредупреждение(, ТекстСообщения, 60);
			СтандартнаяОбработка = Ложь;
		КонецЕсли;

	КонецЕсли;
КонецПроцедуры

#КонецОбласти
