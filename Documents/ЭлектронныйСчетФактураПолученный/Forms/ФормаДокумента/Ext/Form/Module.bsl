﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка реквизитов формы.
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса;
	КонецЕсли;
	
	//Если Не ЗначениеЗаполнено(Объект.ДатаОформления) Тогда
	//	Объект.ДатаОформления = ТекущаяДатаСеанса;	
	//КонецЕсли;
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	УстановитьФункциональныеОпцииФормы();
	
	УстановитьВидКорректировки();
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РаботаСФормами
	
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
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ПодборДокументовЭСФ" 
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		ЗаполнитьТабличнуюЧасть(Параметр.МассивСсылок);
	КонецЕсли;
	                                                              
	// КопированиеСтрокТабличныхЧастей
	Если ИмяСобытия = "БуферОбменаТабличнаяЧастьКопированиеСтрок" Тогда
		КопированиеТабличнойЧастиКлиент.ОбработкаОповещения(Элементы, "Товары");
	КонецЕсли;
	// Конец КопированиеСтрокТабличныхЧастей
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)	
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец РаботаСФормами
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	СписокДокументов = Новый Массив;
	Для Каждого СтрокаТабличнойЧасти Из Объект.Товары Цикл 
		СписокДокументов.Добавить(СтрокаТабличнойЧасти.ДокументОснование);
	КонецЦикла;	
	Оповестить("ЭлектронныйСчетФактураПолученныйПослеЗаписи", СписокДокументов);
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
	
	Объект.БанковскийСчет = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьОсновнойБанковскийСчетОрганизации(Объект.Организация);
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементов();	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Контрагент.
//
&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	СтруктураДанные = ПолучитьДанныеКонтрагентПриИзменении(Объект.Контрагент, Объект.Организация);	
	Объект.ДоговорКонтрагента 		= СтруктураДанные.ДоговорКонтрагента;
	Объект.БанковскийСчетКонтрагента = СтруктураДанные.ОсновнойБанковскийСчет;
	
	ОбработатьИзменениеДоговора();
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Договор контрагента.
//
&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	ОбработатьИзменениеДоговора();
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура КорректировочнаяСчетФактураПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ВидКорректировкиПриИзменении(Элемент)
	Объект.ДокументКорректировочныйЭСФ = Неопределено;
	Объект.СерияКорректируемогоСФ = "";
	Объект.НомерКорректируемогоЭСФ = "";
	Объект.ДатаКорректируемогоЭСФ = "";
	
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ДокументКорректировочныйЭСФПриИзменении(Элемент)
	СтруктураДанные = ПолучитьДанныеДокументКорректировочныйЭСФПриИзменении(Объект.ДокументКорректировочныйЭСФ);
	Объект.СерияКорректируемогоСФ = "";
	Объект.НомерКорректируемогоЭСФ = СтруктураДанные.НомерЭСФ;
	Объект.ДатаКорректируемогоЭСФ = СтруктураДанные.ДатаПоставки;
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

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подбор(Команда)
	
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Организация'"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.Организация",, Отказ);		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидОперации) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'ВидОперации'"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.ВидОперации",, Отказ);		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Контрагент'"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.Контрагент",, Отказ);		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Договор контрагента'"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.ДоговорКонтрагента",, Отказ);		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ФормаОплаты) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Форма оплаты'"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.ФормаОплаты",, Отказ);		
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.Курс) И ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Курс обмена'"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.Курс",, Отказ);		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ЭтоВозврат", Объект.ЭтоКорректировочныйСФ);
		ПараметрыФормы.Вставить("ЭтоУслуги", Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийЭСФ.АктОбОказанииУслуг"));
		ПараметрыФормы.Вставить("Организация", Объект.Организация);
		ПараметрыФормы.Вставить("НачалоПериода", Объект.НачалоПериода);
		ПараметрыФормы.Вставить("КонецПериода", Объект.КонецПериода);
		ПараметрыФормы.Вставить("Контрагент", Объект.Контрагент);
		ПараметрыФормы.Вставить("ДоговорКонтрагента", Объект.ДоговорКонтрагента);
		ПараметрыФормы.Вставить("Курс", Объект.Курс);
		ПараметрыФормы.Вставить("ФормаОплаты", Объект.ФормаОплаты);
		ПараметрыФормы.Вставить("УникальныйИдентификаторФормыВладельца", УникальныйИдентификатор);

		ОткрытьФорму("Документ.ЭлектронныйСчетФактураПолученный.Форма.ФормаПодбораДокументов", ПараметрыФормы, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
					
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Элементы.СтраницаТоварыИУслуги.Заголовок = ?(Объект.ВидОперации = Перечисления.ВидыОперацийЭСФ.АктОбОказанииУслуг,
													НСтр("ru = 'Услуги'"), НСтр("ru = 'Товары'"));
													
	Элементы.ВидКорректировки.Видимость = Объект.ЭтоКорректировочныйСФ;
	Элементы.ДокументКорректировочныйЭСФ.Видимость = Объект.ЭтоКорректировочныйСФ И ВидКорректировки = 0;
	Элементы.НомерКорректируемогоЭСФ.Видимость = Объект.ЭтоКорректировочныйСФ;
	Элементы.СерияКорректируемогоСФ.Видимость = Объект.ЭтоКорректировочныйСФ И ВидКорректировки = 1;
	Элементы.ДатаКорректируемогоЭСФ.Видимость = Объект.ЭтоКорректировочныйСФ;
	Элементы.КодПричиныКорректировки.Видимость = Объект.ЭтоКорректировочныйСФ;
	
	Если ВидКорректировки = 0 Тогда 
		Элементы.НомерКорректируемогоЭСФ.ТолькоПросмотр = Истина;
		Элементы.ДатаКорректируемогоЭСФ.ТолькоПросмотр = Истина;
	Иначе 
		Элементы.СерияКорректируемогоСФ.ТолькоПросмотр = Ложь;
		Элементы.НомерКорректируемогоЭСФ.ТолькоПросмотр = Ложь;
		Элементы.ДатаКорректируемогоЭСФ.ТолькоПросмотр = Ложь;
	КонецЕсли;	
	
	// Видимость валютных сумм.
	Если Объект.ВалютаДокумента = ВалютаРегламентированногоУчета Тогда 
		Элементы.Курс.Видимость = Ложь;
		Элементы.ТоварыСуммаНДСВВалютеРеглУчета.Видимость = Ложь;
		Элементы.ТоварыСуммаНСПВВалютеРеглУчета.Видимость = Ложь;
		Элементы.ТоварыВсегоВВалютеРеглУчета.Видимость = Ложь;
	Иначе
		Элементы.Курс.Видимость = Истина;
		Элементы.ТоварыСуммаНДСВВалютеРеглУчета.Видимость = Истина;
		Элементы.ТоварыСуммаНСПВВалютеРеглУчета.Видимость = Истина;
		Элементы.ТоварыВсегоВВалютеРеглУчета.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры	

// Процедура устанавливает функциональные опции формы документа.
//
&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма, Объект.Организация, ДатаДокумента);
КонецПроцедуры

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, ДатаДокумента, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

&НаСервере
Процедура УстановитьВидКорректировки()
	Если ЗначениеЗаполнено(Объект.СерияКорректируемогоСФ) Тогда 
		ВидКорректировки = 1;
	Иначе 
		ВидКорректировки = 0;
	КонецЕсли;	
КонецПроцедуры // УстановитьВидКорректировки()

&НаСервере
Процедура ЗаполнитьТабличнуюЧасть(МассивСсылок)

	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПоступлениеТоваровУслугТовары.Ссылка КАК ДокументОснование,
		|	ПоступлениеТоваровУслугТовары.Номенклатура КАК Номенклатура,
		|	ПоступлениеТоваровУслугТовары.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ПоступлениеТоваровУслугТовары.Номенклатура.КодТНВЭД КАК КодТНВЭД,
		|	ПоступлениеТоваровУслугТовары.Номенклатура.КодГКЭД КАК КодГКЭД,
		|	ПоступлениеТоваровУслугТовары.Количество КАК Количество,
		|	ПоступлениеТоваровУслугТовары.Всего КАК Всего,
		|	ПоступлениеТоваровУслугТовары.СуммаНДС КАК СуммаНДС,
		|	ПоступлениеТоваровУслугТовары.СуммаНСП КАК СуммаНСП,
		|	ПоступлениеТоваровУслугТовары.Всего / ПоступлениеТоваровУслугТовары.Количество КАК Цена,
		|	ПоступлениеТоваровУслугТовары.Всего - ПоступлениеТоваровУслугТовары.СуммаНДС - ПоступлениеТоваровУслугТовары.СуммаНСП КАК Сумма
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
		|ГДЕ
		|	ПоступлениеТоваровУслугТовары.Ссылка В(&МассивСсылок)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПоступлениеТоваровУслугОС.Ссылка,
		|	ПоступлениеТоваровУслугОС.ОсновноеСредство,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	1,
		|	ПоступлениеТоваровУслугОС.Всего,
		|	ПоступлениеТоваровУслугОС.СуммаНДС,
		|	ПоступлениеТоваровУслугОС.СуммаНСП,
		|	ПоступлениеТоваровУслугОС.Всего,
		|	ПоступлениеТоваровУслугОС.Всего - ПоступлениеТоваровУслугОС.СуммаНДС - ПоступлениеТоваровУслугОС.СуммаНСП
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.ОС КАК ПоступлениеТоваровУслугОС
		|ГДЕ
		|	ПоступлениеТоваровУслугОС.Ссылка В(&МассивСсылок)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПоступлениеТоваровУслугУслуги.Ссылка,
		|	ПоступлениеТоваровУслугУслуги.Номенклатура,
		|	ПоступлениеТоваровУслугУслуги.Номенклатура.ЕдиницаИзмерения,
		|	ПоступлениеТоваровУслугУслуги.Номенклатура.КодТНВЭД,
		|	ПоступлениеТоваровУслугУслуги.Номенклатура.КодГКЭД,
		|	ПоступлениеТоваровУслугУслуги.Количество,
		|	ПоступлениеТоваровУслугУслуги.Всего,
		|	ПоступлениеТоваровУслугУслуги.СуммаНДС,
		|	ПоступлениеТоваровУслугУслуги.СуммаНСП,
		|	ПоступлениеТоваровУслугУслуги.Всего / ПоступлениеТоваровУслугУслуги.Количество,
		|	ПоступлениеТоваровУслугУслуги.Всего - ПоступлениеТоваровУслугУслуги.СуммаНДС - ПоступлениеТоваровУслугУслуги.СуммаНСП
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.Услуги КАК ПоступлениеТоваровУслугУслуги
		|ГДЕ
		|	ПоступлениеТоваровУслугУслуги.Ссылка В(&МассивСсылок)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВозвратТоваровПоставщикуТовары.Ссылка,
		|	ВозвратТоваровПоставщикуТовары.Номенклатура,
		|	ВозвратТоваровПоставщикуТовары.Номенклатура.ЕдиницаИзмерения,
		|	ВозвратТоваровПоставщикуТовары.Номенклатура.КодТНВЭД,
		|	ВозвратТоваровПоставщикуТовары.Номенклатура.КодГКЭД,
		|	ВозвратТоваровПоставщикуТовары.Количество,
		|	ВозвратТоваровПоставщикуТовары.Всего,
		|	ВозвратТоваровПоставщикуТовары.СуммаНДС,
		|	ВозвратТоваровПоставщикуТовары.СуммаНСП,
		|	ВозвратТоваровПоставщикуТовары.Всего / ВозвратТоваровПоставщикуТовары.Количество,
		|	ВозвратТоваровПоставщикуТовары.Всего - ВозвратТоваровПоставщикуТовары.СуммаНДС - ВозвратТоваровПоставщикуТовары.СуммаНСП
		|ИЗ
		|	Документ.ВозвратТоваровПоставщику.Товары КАК ВозвратТоваровПоставщикуТовары
		|ГДЕ
		|	ВозвратТоваровПоставщикуТовары.Ссылка В(&МассивСсылок)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВозвратТоваровПоставщикуОС.Ссылка,
		|	ВозвратТоваровПоставщикуОС.ОсновноеСредство,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	1,
		|	ВозвратТоваровПоставщикуОС.Всего,
		|	ВозвратТоваровПоставщикуОС.СуммаНДС,
		|	ВозвратТоваровПоставщикуОС.СуммаНСП,
		|	ВозвратТоваровПоставщикуОС.Всего,
		|	ВозвратТоваровПоставщикуОС.Всего - ВозвратТоваровПоставщикуОС.СуммаНДС - ВозвратТоваровПоставщикуОС.СуммаНСП
		|ИЗ
		|	Документ.ВозвратТоваровПоставщику.ОС КАК ВозвратТоваровПоставщикуОС
		|ГДЕ
		|	ВозвратТоваровПоставщикуОС.Ссылка В(&МассивСсылок)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВозвратТоваровПоставщикуУслуги.Ссылка,
		|	ВозвратТоваровПоставщикуУслуги.Номенклатура,
		|	ВозвратТоваровПоставщикуУслуги.Номенклатура.ЕдиницаИзмерения,
		|	ВозвратТоваровПоставщикуУслуги.Номенклатура.КодТНВЭД,
		|	ВозвратТоваровПоставщикуУслуги.Номенклатура.КодГКЭД,
		|	ВозвратТоваровПоставщикуУслуги.Количество,
		|	ВозвратТоваровПоставщикуУслуги.Всего,
		|	ВозвратТоваровПоставщикуУслуги.СуммаНДС,
		|	ВозвратТоваровПоставщикуУслуги.СуммаНСП,
		|	ВозвратТоваровПоставщикуУслуги.Всего / ВозвратТоваровПоставщикуУслуги.Количество,
		|	ВозвратТоваровПоставщикуУслуги.Всего - ВозвратТоваровПоставщикуУслуги.СуммаНДС - ВозвратТоваровПоставщикуУслуги.СуммаНСП
		|ИЗ
		|	Документ.ВозвратТоваровПоставщику.Услуги КАК ВозвратТоваровПоставщикуУслуги
		|ГДЕ
		|	ВозвратТоваровПоставщикуУслуги.Ссылка В(&МассивСсылок)";
	Запрос.УстановитьПараметр("СтавкаНСППрочее", Справочники.СтавкиНСП.Прочее);
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтрокаТабличнойЧасти = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Выборка);
	КонецЦикла;	
КонецПроцедуры

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
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
		
	СтруктураДанные.Вставить(
		"ОсновнойБанковскийСчет",
		Объект.Контрагент.ОсновнойБанковскийСчет);	
		
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеКонтрагентПриИзменении()

// Получает договор по умолчанию
//
&НаСервереБезКонтекста
Функция ПолучитьДоговорПоУмолчанию(Документ, Контрагент, Организация)
	
	МенеджерСправочника = Справочники.ДоговорыКонтрагентов;
	
	СписокВидовДоговоров = МенеджерСправочника.ВидыДоговораДляДокумента(Документ);
	ДоговорПоУмолчанию = МенеджерСправочника.ПолучитьДоговорПоУмолчаниюПоОрганизацииВидуДоговора(Контрагент, Организация, СписокВидовДоговоров);
	
	Возврат ДоговорПоУмолчанию;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьИзменениеДоговора(МодифицированДоговор = Ложь)
	
	СтруктураДанные = ПолучитьДанныеДоговорПриИзменении(Объект.ДоговорКонтрагента);
	
	Объект.ВалютаДокумента = СтруктураДанные.ВалютаРасчетов;
	
	Если Объект.ВалютаДокумента = ВалютаРегламентированногоУчета Тогда
		Объект.Курс = 1;
	КонецЕсли;	
		
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Получает набор данных с сервера для процедуры ДоговорПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеДоговорПриИзменении(ДоговорКонтрагента)
	
	СтруктураДанные = Новый Структура;
	
	СтруктураДанные.Вставить(
		"ВалютаРасчетов",
		ДоговорКонтрагента.ВалютаРасчетов);
		
	//СтруктураДанные.Вставить(
	//	"КодКодаПоставкиНДС",
	//	ДоговорКонтрагента.КодПоставкиНДС.Код);
	//	
	//СтруктураДанные.Вставить(
	//	"КодВидаПоставкиНДС",
	//	ДоговорКонтрагента.КодПоставкиНДС.Владелец.Код);
	//	
	//СтруктураДанные.Вставить(
	//	"НомерДоговора",
	//	ДоговорКонтрагента.НомерДоговора);
	//	
	//СтруктураДанные.Вставить(
	//	"ДатаДоговора",
	//	ДоговорКонтрагента.ДатаДоговора);	
		
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДоговорПриИзменении()

// Получает набор данных с сервера для процедуры ДоговорПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеДокументКорректировочныйЭСФПриИзменении(ДокументКорректировочныйЭСФ)
	
	СтруктураДанные = Новый Структура;
	
	СтруктураДанные.Вставить(
		"НомерЭСФ",
		ДокументКорректировочныйЭСФ.НомерЭСФ);
		
	СтруктураДанные.Вставить(
		"ДатаПоставки",
		ДокументКорректировочныйЭСФ.ДатаПоставки);
		
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДоговорПриИзменении()

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
