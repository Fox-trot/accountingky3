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
	
	ОбновитьПодвал();
	
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
	
	Если Объект.Организация.Пустая() Тогда
		Объект.СписокСчетов.Очистить();
	Иначе
		ЗаполнитьСписокСчетовНаСервере();		
	КонецЕсли;
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
	
	Если Объект.Контрагент.Пустая() Тогда
		Объект.СписокСчетов.Очистить();
	Иначе
		ЗаполнитьСписокСчетовНаСервере();		
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Договор контрагента.
//
&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	ОбработатьИзменениеДоговора();
	ЗаполнитьСписокСчетовНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	Объект.СписокСчетов.Очистить();
	
	Если ЗначениеЗаполнено(Объект.ДатаНачала) Тогда
		Если НЕ ЗначениеЗаполнено(Объект.ДатаОкончания) Тогда
			Объект.ДатаОкончания = КонецМесяца(Объект.ДатаНачала);		
		КонецЕсли;	
		
		КорректностьДат = ПроверитьКорректностьУказаныхДат("ДатаНачала");
		
		Если КорректностьДат И НЕ Объект.Контрагент.Пустая() Тогда
			ЗаполнитьСписокСчетовНаСервере();
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	
	Объект.СписокСчетов.Очистить();
	
	КорректностьДат = ПроверитьКорректностьУказаныхДат("ДатаОкончания");
	
	Если КорректностьДат И НЕ Объект.Контрагент.Пустая() Тогда
		ЗаполнитьСписокСчетовНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаСверкиПриИзменении(Элемент)
	
	ЗаполнитьСписокСчетовНаСервере();	
	
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

#Область ОбработчикиСобытийЭлементовТаблицыФормыПоДаннымОрганизации

&НаКлиенте
Процедура ПоДаннымОрганизацииДебетПриИзменении(Элемент)
	ПересчитатьОстатки();
	ОбновитьПодвал("ПоОрганизации");
КонецПроцедуры

&НаКлиенте
Процедура ПоДаннымОрганизацииКредитПриИзменении(Элемент)
	ПересчитатьОстатки();
	ОбновитьПодвал("ПоОрганизации");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПоДаннымОрганизации

&НаКлиенте
Процедура ПоДаннымКонтрагентаДебетПриИзменении(Элемент)
	ПересчитатьОстатки();
	ОбновитьПодвал("ПоКонтрагенту");
КонецПроцедуры

&НаКлиенте
Процедура ПоДаннымКонтрагентаКредитПриИзменении(Элемент)
	ПересчитатьОстатки();
	ОбновитьПодвал("ПоКонтрагенту");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоДаннымОрганизации(Команда)
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Организация'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Организация",, Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Контрагент'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Контрагент",, Отказ);
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
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет предварительно очищена. Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе 
		ЗаполнитьПоДаннымОрганизацииНаСервере();
		ПересчитатьОстатки();
		ОбновитьПодвал("ПоОрганизации");
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
		ОбновитьПодвал("ПоКонтрагенту");
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
		ОбновитьПодвал("ПоОрганизации");
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧастьПоДаннымКонтрагента(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.ПоДаннымКонтрагента.Очистить();
		ЗаполнитьПоДаннымКонтрагентаНаКлиенте();
		ПересчитатьОстатки();
		ОбновитьПодвал("ПоКонтрагенту");
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
	Элементы.СтраницаСписокСчетов.Доступность 			= Ложь;
	Элементы.ДатаНачала.Доступность 		 			= Ложь;
	Элементы.ДатаОкончания.Доступность 	 				= Ложь;
		
	Если НЕ Объект.СверкаСогласована Тогда
		Элементы.Организация.Доступность 		  			= Истина;
		Элементы.СтраницаПоДаннымОрганизации.Доступность 	= Истина;
		Элементы.СтраницаПоДаннымКонтрагента.Доступность 	= Истина;
		Элементы.Контрагент.Доступность         			= Истина;
		Элементы.ДоговорКонтрагента.Доступность				= Истина;
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
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ХозрасчетныйОстаткиИОбороты.Счет КАК СчетУчета
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(
		|			&ДатаНачала,
		|			&ДатаОкончания,
		|			,
		|			,
		|			Счет <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НДСНаАвансы),
		|			&ВидыСубконто,
		|			Организация = &Организация
		|				И Валюта = &Валюта
		|				И Субконто1 = &Контрагент
		|				И Субконто2 = &Договор) КАК ХозрасчетныйОстаткиИОбороты
		|ГДЕ
		|	НЕ &СверкаПоСоцФонду
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних.СчетУчетаРасчетовГНПФР
		|ИЗ
		|	ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних КАК ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних.СчетУчетаРасчетовМСФ
		|ИЗ
		|	ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних КАК ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних.СчетУчетаРасчетовФОТФ
		|ИЗ
		|	ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних КАК ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних.СчетУчетаРасчетовПФФ
		|ИЗ
		|	ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних КАК ВременнаяТаблицаУчетнаяПолитикаПоПерсоналуСрезПоследних";
	ВидыСубконто = Новый Массив();
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	Если Объект.ДоговорКонтрагента.Пустая() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Субконто2 = &Договор", "");
	КонецЕсли;
	
	Если Объект.ВалютаСверки.Пустая() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Валюта = &Валюта", "");		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Период", 			ДатаДокумента);	
	Запрос.УстановитьПараметр("Организация", 		Объект.Организация);
	Запрос.УстановитьПараметр("СверкаПоСоцФонду", 	Объект.СверкаПоСоцФонду);	
	Запрос.УстановитьПараметр("Контрагент", 		Объект.Контрагент);
	Запрос.УстановитьПараметр("Договор", 			Объект.ДоговорКонтрагента);
	Запрос.УстановитьПараметр("ДатаНачала", 		НачалоДня(Объект.ДатаНачала));
	Запрос.УстановитьПараметр("ДатаОкончания", 		КонецДня(Объект.ДатаОкончания));
	Запрос.УстановитьПараметр("Валюта",   			Объект.ВалютаСверки);
	Запрос.УстановитьПараметр("ВидыСубконто",   	ВидыСубконто);
	
	Объект.СписокСчетов.Загрузить(Запрос.Выполнить().Выгрузить());
	Объект.СписокСчетов.Сортировать("СчетУчета");
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

&НаСервере
Процедура ПересчитатьОстатки()
	МассивСчетов = Новый Массив();
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.СписокСчетов Цикл		
		МассивСчетов.Добавить(СтрокаТабличнойЧасти.СчетУчета);		
	КонецЦикла;	
	
	Объект.ОстатокНаНачало = ОстатокНаНачало(Объект.Организация, Объект.ДатаНачала, Объект.Контрагент, МассивСчетов, Объект.ВалютаСверки, Объект.ДоговорКонтрагента);
	Объект.ОстатокНаНачалоПоВсемДоговорам = ОстатокНаНачало(Объект.Организация, Объект.ДатаНачала, Объект.Контрагент, МассивСчетов, Объект.ВалютаСверки);	
	Объект.ОстатокНаКонец = Объект.ОстатокНаНачало + Объект.ПоДаннымОрганизации.Итог("СуммаДт") -  Объект.ПоДаннымОрганизации.Итог("СуммаКт");
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОстатокНаНачало(Организация, Дата, Контрагент, МассивСчетов, Валюта, ДоговорКонтрагента = Неопределено)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХозрасчетныйОстатки.СуммаОстаток,
		|	ХозрасчетныйОстатки.ВалютнаяСуммаОстаток
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Дата, 
		|			Счет В (&МассивСчетов),
		|			,
		|			Организация = &Организация
		|				И Валюта = &Валюта
		|				И Субконто1 = &Контрагент
		|				И Субконто2 = &Договор) КАК ХозрасчетныйОстатки";
	
	Если Валюта = Справочники.Валюты.ПустаяСсылка() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Валюта = &Валюта", "");	
	КонецЕсли;	
	
	Если ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка() ИЛИ ДоговорКонтрагента = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Субконто2 = &Договор", "");	
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Дата", 			Дата);
	Запрос.УстановитьПараметр("Организация", 	Организация);
	Запрос.УстановитьПараметр("МассивСчетов", 	МассивСчетов);
	Запрос.УстановитьПараметр("Контрагент",		Контрагент);
	Запрос.УстановитьПараметр("Валюта", 		Валюта);
	Запрос.УстановитьПараметр("Договор", 		ДоговорКонтрагента);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Если Валюта = Справочники.Валюты.ПустаяСсылка() Тогда
			Возврат ВыборкаДетальныеЗаписи.СуммаОстаток;
		Иначе
			Возврат ВыборкаДетальныеЗаписи.ВалютнаяСуммаОстаток;
		КонецЕсли;			
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

&НаКлиенте
Процедура ОбновитьПодвал(ВидОбновления = Неопределено)

	Если ВидОбновления = "ПоОрганизации" ИЛИ ВидОбновления = Неопределено Тогда
		ДебетПоОрганизации = Объект.ПоДаннымОрганизации.Итог("СуммаДт");
		КредитПоОрганизации = Объект.ПоДаннымОрганизации.Итог("СуммаКт");
		
		//Если ДебетПоОрганизации > КредитПоОрганизации Тогда
		//	ДолгЗаКонтрагентомПоОрганизации = ДебетПоОрганизации - КредитПоОрганизации;
		//	
		//ИначеЕсли ДебетПоОрганизации < КредитПоОрганизации Тогда	
		//	ДолгЗаОрганизациейПоОрганизации = КредитПоОрганизации - ДебетПоОрганизации;
		//КонецЕсли;
		
		Если Объект.ОстатокНаНачало > 0 Тогда
			Элементы.СальдоНачальноеПоОрганизации.Заголовок = "Долг за контрагентом";
			СальдоНачальноеПоОрганизации = Объект.ОстатокНаНачало;
			
			СальдоКонечное = СальдоНачальноеПоОрганизации + ДебетПоОрганизации - КредитПоОрганизации;
			
			Если СальдоКонечное > 0 Тогда
				Элементы.СальдоКонечноеПоОрганизации.Заголовок = "Долг за контрагентом";
				СальдоКонечноеПоОрганизации = СальдоКонечное;
			ИначеЕсли СальдоКонечное < 0 Тогда
				Элементы.СальдоКонечноеПоОрганизации.Заголовок = "Долг за организацией";
				СальдоКонечноеПоОрганизации = -СальдоКонечное;
			Иначе
				Элементы.СальдоКонечноеПоОрганизации.Заголовок = "Сальдо";
				СальдоКонечноеПоОрганизации = 0;
			КонецЕсли;
			
		ИначеЕсли Объект.ОстатокНаНачало < 0 Тогда
			Элементы.СальдоНачальноеПоОрганизации.Заголовок = "Долг за организацией";
			СальдоНачальноеПоОрганизации = -Объект.ОстатокНаНачало;
			
			СальдоКонечное = СальдоНачальноеПоОрганизации + КредитПоОрганизации - ДебетПоОрганизации;
			
			Если СальдоКонечное > 0 Тогда
				Элементы.СальдоКонечноеПоОрганизации.Заголовок = "Долг за организацией";
				СальдоКонечноеПоОрганизации = СальдоКонечное;
			ИначеЕсли СальдоКонечное < 0 Тогда
				Элементы.СальдоКонечноеПоОрганизации.Заголовок = "Долг за контрагентом";
				СальдоКонечноеПоОрганизации = -СальдоКонечное;
			Иначе
				Элементы.СальдоКонечноеПоОрганизации.Заголовок = "Сальдо";
				СальдоКонечноеПоОрганизации = 0;
			КонецЕсли;
			
		Иначе
			Элементы.СальдоНачальноеПоОрганизации.Заголовок = "Сальдо";
			СальдоНачальноеПоОрганизации = 0;
			
			СальдоКонечное = ДебетПоОрганизации - КредитПоОрганизации;
			
			Если СальдоКонечное > 0 Тогда
				Элементы.СальдоКонечноеПоОрганизации.Заголовок = "Долг за контрагентом";
				СальдоКонечноеПоОрганизации = СальдоКонечное;
			ИначеЕсли СальдоКонечное < 0 Тогда
				Элементы.СальдоКонечноеПоОрганизации.Заголовок = "Долг за организацией";
				СальдоКонечноеПоОрганизации = -СальдоКонечное;
			Иначе
				Элементы.СальдоКонечноеПоОрганизации.Заголовок = "Сальдо";
				СальдоКонечноеПоОрганизации = 0;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ВидОбновления = "ПоКонтрагенту" ИЛИ ВидОбновления = Неопределено Тогда
		ДебетПоКонтрагенту = Объект.ПоДаннымКонтрагента.Итог("СуммаДт");
		КредитПоКонтрагенту = Объект.ПоДаннымКонтрагента.Итог("СуммаКт");
		
		Если Объект.ОстатокНаНачало > 0 Тогда
			Элементы.СальдоНачальноеПоКонтрагенту.Заголовок = "Сальдо Кт";
			СальдоНачальноеПоКонтрагенту = Объект.ОстатокНаНачало;
			
			СальдоКонечное = СальдоНачальноеПоКонтрагенту + КредитПоКонтрагенту - ДебетПоКонтрагенту;
			
			Если СальдоКонечное > 0 Тогда
				Элементы.СальдоКонечноеПоКонтрагенту.Заголовок = "Сальдо Кт";
				СальдоКонечноеПоКонтрагенту = СальдоКонечное;
			ИначеЕсли СальдоКонечное < 0 Тогда
				Элементы.СальдоКонечноеПоКонтрагенту.Заголовок = "Сальдо Дт";
				СальдоКонечноеПоКонтрагенту = -СальдоКонечное;
			Иначе
				Элементы.СальдоКонечноеПоКонтрагенту.Заголовок = "Сальдо";
				СальдоКонечноеПоКонтрагенту = 0;
			КонецЕсли;
			
		ИначеЕсли Объект.ОстатокНаНачало < 0 Тогда
			Элементы.СальдоНачальноеПоКонтрагенту.Заголовок = "Сальдо Дт";
			СальдоНачальноеПоКонтрагенту = -Объект.ОстатокНаНачало;
			
			СальдоКонечное = СальдоНачальноеПоКонтрагенту + ДебетПоКонтрагенту - КредитПоКонтрагенту;
			
			Если СальдоКонечное > 0 Тогда
				Элементы.СальдоКонечноеПоКонтрагенту.Заголовок = "Сальдо Дт";
				СальдоКонечноеПоКонтрагенту = СальдоКонечное;
			ИначеЕсли СальдоКонечное < 0 Тогда
				Элементы.СальдоКонечноеПоКонтрагенту.Заголовок = "Сальдо Кт";
				СальдоКонечноеПоКонтрагенту = -СальдоКонечное;
			Иначе
				Элементы.СальдоКонечноеПоКонтрагенту.Заголовок = "Сальдо";
				СальдоКонечноеПоКонтрагенту = 0;
			КонецЕсли;
			
		Иначе
			Элементы.СальдоНачальноеПоКонтрагенту.Заголовок = "Сальдо";
			СальдоНачальноеПоКонтрагенту = 0;
			
			СальдоКонечное = ДебетПоКонтрагенту - КредитПоКонтрагенту;
			
			Если СальдоКонечное > 0 Тогда
				Элементы.СальдоКонечноеПоКонтрагенту.Заголовок = "Сальдо Дт";
				СальдоКонечноеПоКонтрагенту = СальдоКонечное;
			ИначеЕсли СальдоКонечное < 0 Тогда
				Элементы.СальдоКонечноеПоКонтрагенту.Заголовок = "Сальдо Кт";
				СальдоКонечноеПоКонтрагенту = -СальдоКонечное;
			Иначе
				Элементы.СальдоКонечноеПоКонтрагенту.Заголовок = "Сальдо";
				СальдоКонечноеПоКонтрагенту = 0;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Функция проверки корректности введенных дат начала и окончания.
//
// Возвращаемое значение:
//	Ложь/Истина - Булево - признак правильности введенных дат.
//
&НаКлиенте
Функция ПроверитьКорректностьУказаныхДат(Дата)

	Если Объект.ДатаНачала > Объект.ДатаОкончания Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Дата начала периода не может быть больше даты окончания.'"));
		
		Если Дата = "ДатаНачала" Тогда
			Объект.ДатаНачала = Дата("00010101");	
		Иначе
			Объект.ДатаОкончания = Дата("00010101");
		КонецЕсли;
		
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;	

КонецФункции

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
