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
	
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
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

// Процедура - обработчик события ПриИзменении поля ввода Контрагент.
//
&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	СтруктураДанные = ПолучитьДанныеКонтрагентПриИзменении(Объект.Контрагент, Объект.Организация);
	Объект.ДоговорКонтрагента = СтруктураДанные.ДоговорКонтрагента;
	
	ОбработатьИзменениеДоговора();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Договор контрагента.
//
&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	ОбработатьИзменениеДоговора();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода СверткаПоСФ.
//
&НаКлиенте
Процедура СверткаПоСФПриИзменении(Элемент)
	Объект.СписокСчетов.Очистить();
	Если Объект.СверкаПоСоцФонду Тогда  
		Элементы.Контрагент.Видимость = Ложь;
		Элементы.ДоговорКонтрагента.Видимость = Ложь;
	Иначе 
		Элементы.Контрагент.Видимость = Истина;
		Элементы.ДоговорКонтрагента.Видимость = Истина;
	КонецЕсли;
	ЗаполнитьСписокСчетовНаСервере();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода СверткаСогласована.
//
&НаКлиенте
Процедура СверткаСогласованаПриИзменении(Элемент)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоДаннымОрганизации(Команда)
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполен Контрагент! Заполнение документа отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Контрагент", , Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаНачала)
		Или Не ЗначениеЗаполнено(Объект.ДатаОкончания)
		Или Объект.ДатаНачала > Объект.ДатаОкончания Тогда
		ТекстСообщения = НСтр("ru = 'Не верно задан период сверки взаиморасчетов! Заполнение документа отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ДатаНачала", , Отказ);
	КонецЕсли;
	
	Если Отказ Тогда 
		Возврат
	КонецЕсли;	
	
	Если Объект.ПоДаннымОрганизации.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧастьПоДаннымОрганизации", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет перезаполнена! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе 
		ЗаполнитьПоДаннымОрганизацииНаСервере();
		ПересчитатьОстатки();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДаннымКонтрагента(Команда)
	Отказ = Ложь;

	Если Отказ Тогда 
		Возврат
	КонецЕсли;	
	
	Если Объект.ПоДаннымКонтрагента.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧастьПоДаннымКонтрагента", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет перезаполнена! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе 
		ЗаполнитьПоДаннымКонтрагентаНаКлиенте();
		ПересчитатьОстатки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокСчетов(Команда)
	
	Если Объект.СписокСчетов.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧастьСписокСчетов", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет перезаполнена! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе 
		ЗаполнитьСписокСчетовНаСервере();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧастьПоДаннымОрганизации(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
        Объект.ПоДаннымОрганизации.Очистить();
		ЗаполнитьПоДаннымОрганизацииНаСервере();
		ПересчитатьОстатки();
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧастьПоДаннымКонтрагента(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.ПоДаннымКонтрагента.Очистить();
		ЗаполнитьПоДаннымКонтрагентаНаКлиенте();
		ПересчитатьОстатки();
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧастьСписокСчетов(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.СписокСчетов.Очистить();
		ЗаполнитьСписокСчетовНаСервере();
    КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Элементы.Организация.Доступность		  			= Ложь;
	Элементы.СтраницаПоДаннымОрганизации.Доступность 	= Ложь;
	Элементы.СтраницаПоДаннымКонтрагента.Доступность 	= Ложь;
	Элементы.Контрагент.Доступность          			= Ложь;
	Элементы.ДоговорКонтрагента.Доступность				= Ложь;
	Элементы.ОстатокНаНачало.Доступность   				= Ложь;
	Элементы.СтраницаСписокСчетов.Доступность 			= Ложь;
	Элементы.ДатаНачала.Доступность 		 			= Ложь;
	Элементы.ДатаОкончания.Доступность 	 				= Ложь;
		
	Если НЕ Объект.СверкаСогласована Тогда
		Элементы.Организация.Доступность 		  			= Истина;
		Элементы.СтраницаПоДаннымОрганизации.Доступность 	= Истина;
		Элементы.СтраницаПоДаннымКонтрагента.Доступность 	= Истина;
		Элементы.Контрагент.Доступность         			= Истина;
		Элементы.ДоговорКонтрагента.Доступность				= Истина;
		Элементы.ОстатокНаНачало.Доступность     			= Истина;
		Элементы.СтраницаСписокСчетов.Доступность 			= Истина;
		Элементы.ДатаНачала.Доступность 		  			= Истина;
		Элементы.ДатаОкончания.Доступность 	  				= Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		Элементы.ВалютаСверки.ТолькоПросмотр = Истина;	
	Иначе
		Элементы.ВалютаСверки.ТолькоПросмотр = Ложь;
	КонецЕсли;	
КонецПроцедуры 

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

&НаСервере
Процедура ЗаполнитьПоДаннымОрганизацииНаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьПоДаннымБухгалтерскогоУчета();	
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДаннымКонтрагентаНаКлиенте()
	ТаблицаПоДаннымОрганизации = Объект.ПоДаннымОрганизации.Выгрузить();
	ТаблицаПоДаннымОрганизации.Колонки.СуммаДт.Имя = "КредитК";
	ТаблицаПоДаннымОрганизации.Колонки.СуммаКт.Имя = "СуммаДт";
	ТаблицаПоДаннымОрганизации.Колонки.КредитК.Имя = "СуммаКт";
	
	Объект.ПоДаннымКонтрагента.Загрузить(ТаблицаПоДаннымОрганизации);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокСчетовНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УчетнаяПолитикаПоПерсоналуСрезПоследних.Организация,
		|	УчетнаяПолитикаПоПерсоналуСрезПоследних.СчетУчетаРасчетовГНПФР,
		|	УчетнаяПолитикаПоПерсоналуСрезПоследних.СчетУчетаРасчетовМСФ,
		|	УчетнаяПолитикаПоПерсоналуСрезПоследних.СчетУчетаРасчетовФОТФ,
		|	УчетнаяПолитикаПоПерсоналуСрезПоследних.СчетУчетаРасчетовПФФ
		|ПОМЕСТИТЬ ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних
		|ИЗ
		|	РегистрСведений.УчетнаяПолитикаПоПерсоналу.СрезПоследних(&Период, Организация = &Организация) КАК УчетнаяПолитикаПоПерсоналуСрезПоследних
		|ГДЕ
		|	&СверкаПоСоцФонду
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Хозрасчетный.Ссылка КАК СчетУчета,
		|	ИСТИНА КАК УчаствуетВРасчетах
		|ИЗ
		|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
		|ГДЕ
		|	Хозрасчетный.ВидыСубконто.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры)
		|	И НЕ &СверкаПоСоцФонду
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних.СчетУчетаРасчетовГНПФР,
		|	ИСТИНА
		|ИЗ
		|	ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних КАК ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних.СчетУчетаРасчетовМСФ,
		|	ИСТИНА
		|ИЗ
		|	ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних КАК ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних.СчетУчетаРасчетовФОТФ,
		|	ИСТИНА
		|ИЗ
		|	ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних КАК ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних.СчетУчетаРасчетовПФФ,
		|	ИСТИНА
		|ИЗ
		|	ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних КАК ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних";
	Запрос.УстановитьПараметр("Период", ДатаДокумента);	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("СверкаПоСоцФонду", Объект.СверкаПоСоцФонду);
	
	Объект.СписокСчетов.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры

// Получает набор данных с сервера для процедуры КонтрагентПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеКонтрагентПриИзменении(Контрагент, Организация)
	
	ДоговорПоУмолчанию = ПолучитьДоговорПоУмолчанию(Объект.Ссылка, Контрагент, Организация);
	
	СтруктураДанные = Новый Структура;
	
	СтруктураДанные.Вставить(
		"ДоговорКонтрагента",
		ДоговорПоУмолчанию);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеКонтрагентПриИзменении()

// Получает договор по умолчанию
//
&НаСервереБезКонтекста
Функция ПолучитьДоговорПоУмолчанию(Документ, Контрагент, Организация)
	
	МенеджерСправочника = Справочники.ДоговорыКонтрагентов;
	
	СписокВидовДоговоров = МенеджерСправочника.ПолучитьСписокВидовДоговораДляДокумента(Документ);
	ДоговорПоУмолчанию = МенеджерСправочника.ПолучитьДоговорПоУмолчаниюПоОрганизацииВидуДоговора(Контрагент, Организация, СписокВидовДоговоров);
	
	Возврат ДоговорПоУмолчанию;
	
КонецФункции

&НаКлиенте
Процедура ПересчитатьОстатки()
	МассивСчетов = Новый Массив;
	Для каждого СтрокаСчета Из Объект.СписокСчетов Цикл
		Если Не ЗначениеЗаполнено(СтрокаСчета.СчетУчета) 
			или СтрокаСчета.УчаствуетВРасчетах = Ложь Тогда
			Продолжить;
		Иначе
			МассивСчетов.Добавить(СтрокаСчета.СчетУчета);
		КонецЕсли; 
	КонецЦикла;	
	
	Объект.ОстатокНаНачало = ОстатокНаНачало(Объект.ДатаНачала, Объект.Контрагент, МассивСчетов, Объект.ДоговорКонтрагента);
	Объект.ОстатокНаНачалоПоВсемДоговорам = ОстатокНаНачало(Объект.ДатаНачала, Объект.Контрагент, МассивСчетов, Неопределено);
	
	Объект.ОстатокНаКонец = Объект.ОстатокНаНачало + Объект.ПоДаннымОрганизации.Итог("СуммаДт") -  Объект.ПоДаннымОрганизации.Итог("СуммаКт");
	ОстНаНачК = - Объект.ОстатокНаНачало;
	
	ОстатокНаКонецКонтрагент = - Объект.ОстатокНаНачало + Объект.ПоДаннымКонтрагента.Итог("СуммаДт") -  Объект.ПоДаннымКонтрагента.Итог("СуммаКт");
	ОстНаКонК = ОстатокНаКонецКонтрагент;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОстатокНаНачало(Дата, Контрагент, МассивСчетов, ДоговорКонтрагента = Неопределено)

	ВидыСубконто = Новый Массив;
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХозрасчетныйОстатки.СуммаОстаток
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Дата, 
		|			Счет В (&МассивСчетов),
		|			&ВидыСубконто,
		|			Субконто1 = &Субконто1
		|				И (Субконто2 = &Субконто2
		|					ИЛИ &Субконто2 = НЕОПРЕДЕЛЕНО)) КАК ХозрасчетныйОстатки";
	
	Запрос.УстановитьПараметр("ВидыСубконто", ВидыСубконто);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("МассивСчетов", МассивСчетов);
	Запрос.УстановитьПараметр("Субконто1", Контрагент);
	Запрос.УстановитьПараметр("Субконто2", ДоговорКонтрагента);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.СуммаОстаток;
	Иначе
		Возврат 0;	
	КонецЕсли; 
	
КонецФункции // ()

&НаСервере
Процедура ОбработатьИзменениеДоговора()

	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		Объект.ВалютаСверки = Объект.ДоговорКонтрагента.ВалютаРасчетов;
		Элементы.ВалютаСверки.ТолькоПросмотр = Истина;
	Иначе
		Объект.ВалютаСверки = ВалютаРегламентированногоУчета;
		Элементы.ВалютаСверки.ТолькоПросмотр = Ложь;
	КонецЕсли;	

КонецПроцедуры

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
