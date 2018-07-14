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
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();	
	
	Если Объект.НДСНеПодтвержден Тогда
		ВидСФ = НСтр("ru = 'Подтверждение СФ'");	
	Иначе
		ВидСФ = НСтр("ru = 'Общий СФ'");
	КонецЕсли;	
	
	// КопированиеСтрокТабличныхЧастей
	КопированиеТабличнойЧастиСервер.ПриСозданииНаСевере(Элементы, "Товары");
	// Конец КопированиеСтрокТабличныхЧастей
	
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
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменений
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменений
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // ПриЧтенииНаСервере()

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
	ОбновитьПодвалФормы();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// КопированиеСтрокТабличныхЧастей
	Если ИмяСобытия = "БуферОбменаТабличнаяЧастьКопированиеСтрок" Тогда
		КопированиеТабличнойЧастиКлиент.ОбработкаОповещения(Элементы, "Товары");
	КонецЕсли;
	// Конец КопированиеСтрокТабличныхЧастей
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
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(Объект.Ссылка, Объект.Дата, ДатаПередИзменением, Объект.ВалютаДокумента);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;	
		
		Если НЕ Объект.НДСНеПодтвержден Тогда
			Объект.ДатаСФ = КонецМесяца(Объект.Дата);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.ВалютаДокумента) Тогда
			ПересчитатьКурсКратностьВалютыДокумента(СтруктураДанные);
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

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	СтруктураДанные = ПолучитьДанныеКонтрагентПриИзменении(Объект.Контрагент, Объект.Организация);
	
	Объект.ПризнакСтраны = СтруктураДанные.ПризнакСтраны;
	
	ЗаполнитьРеквизитыПоКонтрагенту();
	ОбработатьИзменениеДоговора();
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	ОбработатьИзменениеДоговора();
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
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

// Процедура - обработчик события ПриИзменении поля ввода СерияБланкаСФ.
//
&НаКлиенте
Процедура СерияБланкаСФПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.СерияБланкаСФ) И (НЕ ЗначениеЗаполнено(Объект.ДатаСФ)) Тогда
		Объект.ДатаСФ = ДатаДокумента;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода НомерБланкаСФ.
//
&НаКлиенте
Процедура НомерБланкаСФПриИзменении(Элемент)
	Если НЕ ЗначениеЗаполнено(Объект.ДатаСФ) Тогда
		Объект.ДатаСФ = ДатаДокумента;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода БезналичныйРасчет.
//
&НаКлиенте
Процедура БезналичныйРасчетПриИзменении(Элемент)
	
	Если Объект.БезналичныйРасчет Тогда
		Объект.ЗначениеСтавкиНСП = 0;
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ВалютаДокумента.
//
&НаКлиенте
Процедура ВалютаДокументаПриИзменении(Элемент)
		
	СтруктураКурсКратность = ПолучитьКурсИКратностьВалюты(Объект.ВалютаДокумента, Объект.Дата);
	                   
	Объект.Курс 	 = ?(СтруктураКурсКратность.Курс = 0, 1, СтруктураКурсКратность.Курс);
	Объект.Кратность = ?(СтруктураКурсКратность.Кратность = 0, 1, СтруктураКурсКратность.Кратность);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ЗначениеСтавкиНДС.
//
&НаКлиенте
Процедура ЗначениеСтавкиНДСПриИзменении(Элемент)
	
	СтранаВходитВЕАЭС = Объект.ПризнакСтраны = ПредопределенноеЗначение("Перечисление.ПризнакиСтраны.ЕАЭС");
	
	// Расчет налогов
	ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьНалогиТабличнойЧастиПоступление(
		Объект,
		"Товары",
		?(СтранаВходитВЕАЭС, Истина, Ложь),
		Объект.ЗначениеСтавкиНДС, 
		Объект.ЗначениеСтавкиНСП,
		?(СтранаВходитВЕАЭС, Истина, Объект.БезналичныйРасчет),
		?(СтранаВходитВЕАЭС, Объект.Курс, 1),
		?(СтранаВходитВЕАЭС, Объект.Кратность, 1));
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ЗначениеСтавкиНСП.
//
&НаКлиенте
Процедура ЗначениеСтавкиНСППриИзменении(Элемент)
	
	СтранаВходитВЕАЭС = Объект.ПризнакСтраны = ПредопределенноеЗначение("Перечисление.ПризнакиСтраны.ЕАЭС");
	
	// Расчет налогов
	ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьНалогиТабличнойЧастиПоступление(
		Объект,
		"Товары",
		?(СтранаВходитВЕАЭС, Истина, Ложь),
		Объект.ЗначениеСтавкиНДС, 
		Объект.ЗначениеСтавкиНСП,
		?(СтранаВходитВЕАЭС, Истина, Объект.БезналичныйРасчет),
		?(СтранаВходитВЕАЭС, Объект.Курс, 1),
		?(СтранаВходитВЕАЭС, Объект.Кратность, 1));
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода РучноеЗаполнениеСпецификаций.
//
&НаКлиенте
Процедура РучноеЗаполнениеСпецификацийПриИзменении(Элемент)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДокументыПоступления

&НаКлиенте
Процедура ДокументыПоступленияПослеУдаления(Элемент)

	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
	Объект.Товары.Очистить();
	Объект.Услуги.Очистить();
	Объект.ОС.Очистить();
	
	Если Объект.ДокументыПоступления.Количество() > 0 Тогда
		ЗаполнитьПоДокументамНаСервере();
	КонецЕсли;
	
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ДокументыПоступленияДокумент.
//
&НаКлиенте
Процедура ДокументыПоступленияДокументПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ДокументыПоступления.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДокументПоступления) Тогда
		СтруктураСумм = ПолучитьСуммыВыбираемогоДокумента(СтрокаТабличнойЧасти.ДокументПоступления);
		
		СтрокаТабличнойЧасти.Сумма 		= СтруктураСумм.Сумма;
		СтрокаТабличнойЧасти.СуммаНДС 	= СтруктураСумм.СуммаНДС;
		СтрокаТабличнойЧасти.СуммаНСП 	= СтруктураСумм.СуммаНСП;
		СтрокаТабличнойЧасти.Всего 		= СтруктураСумм.Всего;
	КонецЕсли;	
		             
	ЗаполнитьПоДокументамНаСервере();
	ОбновитьПодвалФормы();	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура вызывается при нажатии кнопки "Заполнить" 
//
&НаКлиенте
Процедура Заполнить(Команда)
	
	Отказ = Ложь;
	
	// Проверка перед заполнением.
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Для заполнения документа необходимо указать организацию.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Организация",,Отказ)		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Дата) Тогда
		ТекстСообщения = НСтр("ru = 'Для заполнения документа необходимо задать дату.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Дата",,Отказ)		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		ТекстСообщения = НСтр("ru = 'Для заполнения документа необходимо указать контрагента.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Контрагент",,Отказ)		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ВалютаДокумента) Тогда
		ТекстСообщения = НСтр("ru = 'Для заполнения документа необходимо указать валюту.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ВалютаДокумента",,Отказ)		
	КонецЕсли;
	
	Если Не Отказ Тогда	
		Если Объект.ДокументыПоступления.Количество() > 0  ИЛИ Объект.Товары.Количество() > 0
			ИЛИ Объект.Услуги.Количество() > 0 ИЛИ Объект.ОС.Количество() > 0 Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнить", ЭтотОбъект);
			ТекстВопроса = НСтр("ru = 'Табличные части документа будут очищены! Продолжить выполнение операции?'");
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);				
		Иначе
			ЗаполнитьНаСервере();			
		КонецЕсли;	
	КонецЕсли;		
	
	// Проверка после заполнения.
	Если Объект.ДокументыПоступления.Количество() = 0 Тогда 
		ТекстСообщения = НСтр("ru = 'Не найдены документы поступления с незаполненными СФ по указанным отборам.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТекстОповещения = НСтр("ru = 'Заполнение'");
		ТекстПояснения = НСтр("ru = 'Документ заполнен'");
		ПоказатьОповещениеПользователя(ТекстОповещения,, ТекстПояснения, БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	ОбновитьПодвалФормы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнить(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.ДокументыПоступления.Очистить();
		Объект.Товары.Очистить();
		Объект.Услуги.Очистить();
		Объект.ОС.Очистить();
		
		ЗаполнитьНаСервере();
	КонецЕсли; 
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Элементы.ДокументыПоступленияСуммаНСП.Видимость 	= НЕ Объект.БезналичныйРасчет;
	Элементы.ТоварыСуммаНСП.Видимость 					= НЕ Объект.БезналичныйРасчет;
	Элементы.УслугиСуммаНСП.Видимость 					= НЕ Объект.БезналичныйРасчет;
	Элементы.ОССуммаНСП.Видимость 						= НЕ Объект.БезналичныйРасчет;
	Элементы.ИтогиСуммаНСП.Видимость 					= НЕ Объект.БезналичныйРасчет;
	Элементы.ЗначениеСтавкиНСП.Видимость 				= НЕ Объект.БезналичныйРасчет;	
	
	Элементы.СтраницаДокументы.Видимость 				= Не Объект.НДСНеПодтвержден;	
	Элементы.Товары.ТолькоПросмотр 						= Объект.НДСНеПодтвержден И НЕ Объект.РучноеЗаполнениеСпецификаций;
	Элементы.Услуги.ТолькоПросмотр 						= Объект.НДСНеПодтвержден И НЕ Объект.РучноеЗаполнениеСпецификаций;
	Элементы.ОС.ТолькоПросмотр 							= Объект.НДСНеПодтвержден И НЕ Объект.РучноеЗаполнениеСпецификаций;	
	Элементы.РучноеЗаполнениеСпецификаций.Доступность 	= Не Объект.НДСНеПодтвержден;
	Элементы.ГруппаИнформация.Доступность 				= Не Объект.НДСНеПодтвержден;
	Элементы.Номер.Доступность 							= Не Объект.НДСНеПодтвержден;
	Элементы.Контрагент.Доступность 					= Не Объект.НДСНеПодтвержден;
	Элементы.ДоговорКонтрагента.Доступность 			= Не Объект.НДСНеПодтвержден;
	Элементы.ГруппаЗначенияСтавок.Доступность 			= Не Объект.НДСНеПодтвержден;
	Элементы.Организация.Доступность 					= Не Объект.НДСНеПодтвержден;
	Элементы.Группа22.Доступность 						= Не Объект.НДСНеПодтвержден;
	
	Элементы.ВалютаДокумента.Доступность 				= Не ЗначениеЗаполнено(Объект.ДоговорКонтрагента);
КонецПроцедуры 

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДокументСсылка, ДатаНовая, ДатаПередИзменением, ВалютаДокумента)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(ДокументСсылка, ДатаНовая, ДатаПередИзменением);
	ВалютаКурсКратность = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаНовая);
	
	СтруктураДанные = Новый Структура;
	
	СтруктураДанные.Вставить(
		"РазностьДат",
		РазностьДат);
		
	СтруктураДанные.Вставить(
		"ВалютаКурсКратность",
		ВалютаКурсКратность);	
		
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

// Процедура заполняет реквизит "СуммаДокумента",
// табличной части "ДокументыПодбора", при выборе
// самого документа.
//
// Параметры:
//  ТекущийПодобранныйДокумент - ДокументСсылка - ссылка на выбранный документ в ТЧ "ДокументыПодбора".
//  
// Возвращаемое значение:
//  Число - сумма передаваемого в функцию документа.
//
&НаСервере
Функция ПолучитьСуммыВыбираемогоДокумента(ТекущийПодобранныйДокумент)
	
	Структура = Новый Структура();
	
	Структура.Вставить("Сумма", ТекущийПодобранныйДокумент.Товары.Итог("Сумма")
								+ ТекущийПодобранныйДокумент.Услуги.Итог("Сумма")
								+ ТекущийПодобранныйДокумент.ОС.Итог("Сумма"));
								
	Структура.Вставить("СуммаНДС", ТекущийПодобранныйДокумент.Товары.Итог("СуммаНДС")
								+ ТекущийПодобранныйДокумент.Услуги.Итог("СуммаНДС")
								+ ТекущийПодобранныйДокумент.ОС.Итог("СуммаНДС"));
								
	Структура.Вставить("СуммаНСП", ТекущийПодобранныйДокумент.Товары.Итог("СуммаНСП")
								+ ТекущийПодобранныйДокумент.Услуги.Итог("СуммаНСП")
								+ ТекущийПодобранныйДокумент.ОС.Итог("СуммаНСП"));
								
	Структура.Вставить("Всего", ТекущийПодобранныйДокумент.Товары.Итог("Всего")
								+ ТекущийПодобранныйДокумент.Услуги.Итог("Всего")
								+ ТекущийПодобранныйДокумент.ОС.Итог("Всего"));
	
	Возврат Структура;		
КонецФункции

// Процедура заполнения ТЧ "ДокументыПоступления"
//
&НаСервере
Процедура ЗаполнитьНаСервере()

	ОбъектДокумента = РеквизитФормыВЗначение("Объект");
	ОбъектДокумента.ЗаполнитьДокумент();                           	
	ЗначениеВРеквизитФормы(ОбъектДокумента, "Объект");	

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДокументамНаСервере()

	ОбъектДокумента = РеквизитФормыВЗначение("Объект");
	ОбъектДокумента.ЗаполнитьПоПодобраннымДокументам();                           	
	ЗначениеВРеквизитФормы(ОбъектДокумента, "Объект");	

КонецПроцедуры

// Получает набор данных с сервера для процедуры КонтрагентПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеКонтрагентПриИзменении(Контрагент, Организация)
	
	СтруктураДанные = Новый Структура;
	
	СтруктураДанные.Вставить(
		"ПризнакСтраны",
		Контрагент.ПризнакСтраны);
		
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеКонтрагентПриИзменении()

&НаСервереБезКонтекста
Функция ПолучитьКурсИКратностьВалюты(Валюта, Дата)

	Возврат РаботаСКурсамиВалют.ПолучитьКурсВалюты(Валюта, Дата)

КонецФункции // ПолучитьКурсИКратностьВалюты()

// Процедура - Пересчитать курс кратность валюты расчетов
//
// Параметры:
//  СтруктураДанные	- Структура - 
//		* ВалютаКурсКратность - Структура
//			* Курс - Число
//			* Кратность - Число
//
&НаКлиенте
Процедура ПересчитатьКурсКратностьВалютыДокумента(СтруктураДанные)
	
	КурсНовый = ?(СтруктураДанные.ВалютаКурсКратность.Курс = 0, 1, СтруктураДанные.ВалютаКурсКратность.Курс);
	КратностьНовый = ?(СтруктураДанные.ВалютаКурсКратность.Кратность = 0, 1, СтруктураДанные.ВалютаКурсКратность.Кратность);
	
	Если Объект.Курс <> КурсНовый
		Или Объект.Кратность <> КратностьНовый Тогда
		
		КурсВалютыСтрокой = Строка(Объект.Кратность) + " " + СокрЛП(Объект.ВалютаДокумента) + " = " + Строка(Объект.Курс) + " " + СокрЛП(ВалютаРегламентированногоУчета);
		КурсНовыйВалютыСтрокой = Строка(КратностьНовый) + " " + СокрЛП(Объект.ВалютаДокумента) + " = " + Строка(КурсНовый) + " " + СокрЛП(ВалютаРегламентированногоУчета);
		
		ТекстСообщения = СтрШаблон(НСтр("ru = 'На дату документа у валюты расчетов %1 был задан курс.
									|Установить курс расчетов %2 в соответствии с курсом валюты?'"),
									КурсВалютыСтрокой, КурсНовыйВалютыСтрокой);
		
		Режим = РежимДиалогаВопрос.ДаНет;
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ПересчитатьКурсКратностьВалютыДокументаЗавершение", ЭтотОбъект, Новый Структура("КратностьНовый, КурсНовый", КратностьНовый, КурсНовый)), ТекстСообщения, Режим, 0);
		Возврат;
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьКурсКратностьВалютыДокументаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КратностьНовый = ДополнительныеПараметры.КратностьНовый;
	КурсНовый = ДополнительныеПараметры.КурсНовый;
	
	Ответ = Результат;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Объект.Курс = КурсНовый;
		Объект.Кратность = КратностьНовый;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПоКонтрагенту()

	Запрос = Новый Запрос;
	Запрос.Текст =
	    "ВЫБРАТЬ
	    |	СчетаФактурыПолученные.Документ КАК Документ
	    |ПОМЕСТИТЬ ВременнаяТаблицаДокументы
	    |ИЗ
	    |	РегистрСведений.СчетаФактурыПолученные КАК СчетаФактурыПолученные
	    |ГДЕ
	    |	СчетаФактурыПолученные.Документ ССЫЛКА Документ.ПоступлениеТоваровУслуг
	    |
	    |ОБЪЕДИНИТЬ
	    |
	    |ВЫБРАТЬ
	    |	СведенияОПоступлении.ДокументСсылка
	    |ИЗ
	    |	РегистрСведений.СведенияОПоступлении КАК СведенияОПоступлении
	    |ГДЕ
	    |	СведенияОПоступлении.ДокументСсылка ССЫЛКА Документ.ПоступлениеТоваровУслуг
	    |;
	    |
	    |////////////////////////////////////////////////////////////////////////////////
	    |ВЫБРАТЬ ПЕРВЫЕ 1
	    |	ПоступлениеТоваровОбороты.Договор КАК Договор,
	    |	ПоступлениеТоваровОбороты.Договор.ВалютаРасчетов КАК Валюта,
	    |	ПоступлениеТоваровОбороты.БезналичныйРасчет КАК БезналичныйРасчет,
	    |	ПоступлениеТоваровОбороты.ЗначениеСтавкиНДС КАК ЗначениеСтавкиНДС,
	    |	ПоступлениеТоваровОбороты.ЗначениеСтавкиНСП КАК ЗначениеСтавкиНСП
	    |ИЗ
	    |	РегистрНакопления.ПоступлениеТоваров.Обороты(
	    |			&ДатаНачала,
	    |			&ДатаОкончания,
	    |			Регистратор,
	    |			Организация = &Организация
	    |				И Контрагент = &Контрагент) КАК ПоступлениеТоваровОбороты
	    |ГДЕ
	    |	ПоступлениеТоваровОбороты.Контрагент.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.КР)
	    |	И НЕ ПоступлениеТоваровОбороты.Регистратор В
	    |				(ВЫБРАТЬ
	    |					ВременнаяТаблицаДокументы.Документ
	    |				ИЗ
	    |					ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы)
	    |	И ПоступлениеТоваровОбороты.Контрагент.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.КР)
	    |	И ВЫРАЗИТЬ(ПоступлениеТоваровОбороты.Регистратор КАК Документ.ПоступлениеТоваровУслуг).ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Покупка)
	    |
	    |УПОРЯДОЧИТЬ ПО
	    |	ПоступлениеТоваровОбороты.Период УБЫВ";
	Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Контрагент", Объект.Контрагент);

	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Объект.ДоговорКонтрагента 	= Выборка.Договор;
		Объект.ВалютаДокумента 		= Выборка.Валюта;
		Объект.БезналичныйРасчет 	= Выборка.БезналичныйРасчет;
		Объект.ЗначениеСтавкиНДС 	= Выборка.ЗначениеСтавкиНДС;
		Объект.ЗначениеСтавкиНСП 	= Выборка.ЗначениеСтавкиНСП;
	КонецЕсли;	
КонецПроцедуры

// Получает набор данных с сервера для процедуры ДоговорПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеДоговорПриИзменении(Период, ДоговорКонтрагента)
	
	СтруктураДанные = Новый Структура;
	
	СтруктураДанные.Вставить(
		"ВалютаРасчетов",
		ДоговорКонтрагента.ВалютаРасчетов);
		
	СтруктураДанные.Вставить(
		"ВалютаРасчетовКурсКратность",
		РаботаСКурсамиВалют.ПолучитьКурсВалюты(ДоговорКонтрагента.ВалютаРасчетов, Период));
		
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДоговорПриИзменении()

&НаКлиенте
Процедура ОбработатьИзменениеДоговора()

	СтруктураДанные = ПолучитьДанныеДоговорПриИзменении(ДатаДокумента, Объект.ДоговорКонтрагента);	

	Объект.ВалютаДокумента 	= ?(ЗначениеЗаполнено(СтруктураДанные.ВалютаРасчетов), СтруктураДанные.ВалютаРасчетов, ВалютаРегламентированногоУчета);
	Объект.Курс      		= ?(СтруктураДанные.ВалютаРасчетовКурсКратность.Курс = 0, 1, СтруктураДанные.ВалютаРасчетовКурсКратность.Курс);
	Объект.Кратность 		= ?(СтруктураДанные.ВалютаРасчетовКурсКратность.Кратность = 0, 1, СтруктураДанные.ВалютаРасчетовКурсКратность.Кратность);
КонецПроцедуры

// Процедура рассчитывает итоги для подвала формы.
//
&НаКлиенте
Процедура ОбновитьПодвалФормы()
	
	ИтогиВсего = Объект.Товары.Итог("Всего") + Объект.Услуги.Итог("Всего") + Объект.ОС.Итог("Сумма");
	ИтогиСуммаНДС = Объект.Товары.Итог("СуммаНДС") + Объект.Услуги.Итог("СуммаНДС") + Объект.ОС.Итог("СуммаНДС");
	ИтогиСуммаНСП = Объект.Товары.Итог("СуммаНСП") + Объект.Услуги.Итог("СуммаНСП") + Объект.ОС.Итог("СуммаНСП");
	
КонецПроцедуры // ОбновитьПодвалФормы()

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