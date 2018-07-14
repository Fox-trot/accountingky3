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
	ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиОрганизаций(ДатаДокумента, Объект.Организация);
	
	УстановитьФункциональныеОпцииФормы();
	
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
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
	УстановитьТекущуюСтраницу();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "МодифицированДоговораКонтрагента" Тогда
		ОбработатьИзменениеДоговора(Истина);

	ИначеЕсли (ИмяСобытия = "ПодборПоДокументамПроизведен_Заполнить" Или ИмяСобытия = "ПодборПоДокументамПроизведен_Добавить")  
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресДокументовВХранилище = "";
		Параметр.Свойство("АдресДокументовВХранилище", АдресДокументовВХранилище);
		Если ЗначениеЗаполнено(АдресДокументовВХранилище) Тогда
			МассивДокументов = ПолучитьИзВременногоХранилища(АдресДокументовВХранилище);
			Если ИмяСобытия = "ПодборПоДокументамПроизведен_Заполнить" Тогда 
				ЗаполнитьПоДокументамОснованиям(МассивДокументов);
			Иначе
				ДобавитьСтрокиТабличнойЧастиИзДокументаПоступления(МассивДокументов);
			КонецЕсли;
		КонецЕсли;
	Иначе
		ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);	
	КонецЕсли;
	
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
		
		Если ЗначениеЗаполнено(Объект.ВалютаДокумента) Тогда
			ПересчитатьКурсКратностьВалютыДокумента(СтруктураДанные);
		КонецЕсли;	
	КонецЕсли;
	
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);	
	УстановитьФункциональныеОпцииФормы();
	ОбработатьИзменениеУчетнойПолитики();
	ОбработатьИзменениеДоговора();  
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Объект.Номер = "";

	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
	УстановитьФункциональныеОпцииФормы();	
	ОбработатьИзменениеУчетнойПолитики();
	
	СтруктураДанные = ПолучитьДанныеКонтрагентПриИзменении(Объект.Контрагент, Объект.Организация);
	Объект.ДоговорКонтрагента = СтруктураДанные.ДоговорКонтрагента;
	ОбработатьИзменениеДоговора();
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

// Процедура - обработчик события ПриИзменении поля ввода Контрагент.
//
&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	СтруктураДанные = ПолучитьДанныеКонтрагентПриИзменении(Объект.Контрагент, Объект.Организация);
		
	Объект.ДоговорКонтрагента = СтруктураДанные.ДоговорКонтрагента;
	Объект.ПризнакСтраны = СтруктураДанные.ПризнакСтраны;
	
	// Изменение признака страны
	Если Объект.ПризнакСтраны = ПредопределенноеЗначение("Перечисление.ПризнакиСтраны.ЕАЭС")
		ИЛИ Объект.ПризнакСтраны = ПредопределенноеЗначение("Перечисление.ПризнакиСтраны.ИмпортЭкспорт") Тогда
		
		Объект.БезналичныйРасчет = Ложь;
		Объект.ЗначениеСтавкиНДС = 0;
		Объект.ЗначениеСтавкиНСП = 0;
		Объект.СуммаНДС = 0;
		Объект.СуммаНСП = 0;
		Объект.ЗачетНДС = Неопределено;
		
	КонецЕсли;
	
	УстановитьВидимостьДоступностьЭлементов();
	ОбработатьИзменениеДоговора();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Договор контрагента.
//
&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	ОбработатьИзменениеДоговора();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Основание.
//
&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	Объект.Товары.Очистить();
	Объект.ОС.Очистить();
	
	МассивДокументов = Новый Массив;
	МассивДокументов.Добавить(Объект.ДокументОснование);
	ЗаполнитьПоДокументамОснованиям(МассивДокументов);
КонецПроцедуры

&НаКлиенте
Процедура НеВключатьВРеестрСФПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементов();
	
	Если Объект.НеВключатьВРеестрСФ Тогда
		Объект.СерияБланкаСФ = "";
		Объект.НомерБланкаСФ = "";
		Объект.ДатаСФ = Дата(1, 1, 1);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СуммаДопРасходовПриИзменении(Элемент)
	
	РассчитатьСуммыНалогов();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеСтавкиНДСПриИзменении(Элемент)
	
	РассчитатьСуммыНалогов();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеСтавкиНСППриИзменении(Элемент)
	
	РассчитатьСуммыНалогов();
	
КонецПроцедуры

&НаКлиенте
Процедура БезналичныйРасчетПриИзменении(Элемент)
	
	Если Объект.БезналичныйРасчет Тогда
		Объект.ЗначениеСтавкиНСП = 0;
		РассчитатьСуммыНалогов();
	КонецЕсли;
	
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоПоступлению(Команда)
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("ДатаОтбора", ДатаДокумента);
	ПараметрыПодбора.Вставить("УникальныйИдентификаторФормыВладельца", УникальныйИдентификатор);
	ПараметрыПодбора.Вставить("СпособЗаполнения", "Заполнить");
	ОткрытьФорму("Документ.ДополнительныеРасходы.Форма.ФормаПодбораПоДокументам", ПараметрыПодбора);
КонецПроцедуры

// Процедура - обработчик команды командной панели табличной части.
//
&НаКлиенте
Процедура ДобавитьИзПоступления(Команда)
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("ДатаОтбора", ДатаДокумента);
	ПараметрыПодбора.Вставить("УникальныйИдентификаторФормыВладельца", УникальныйИдентификатор);
	ПараметрыПодбора.Вставить("СпособЗаполнения", "Добавить");
	ОткрытьФорму("Документ.ДополнительныеРасходы.Форма.ФормаПодбораПоДокументам", ПараметрыПодбора);
КонецПроцедуры

// Процедура - обработчик команды командной панели табличной части.
//
&НаКлиенте
Процедура РаспределитьРасходы(Команда)
	
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.СпособРаспределения) Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнен способ распределения! Распределение отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.СпособРаспределения",, Отказ);
	КонецЕсли;	
	
	Если Объект.Товары.Количество() = 0 
		И Объект.ОС.Количество() = 0 Тогда  
		ТекстСообщения = НСтр("ru = 'В табличной части ""Товары"" и ""Основные средства"" нет записей! Распределение отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Товары",, Отказ);
	КонецЕсли;
	
	Если Объект.СуммаДопРасходов = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Сумма дополнительных расходов к распределению равна 0. Распределение отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.СуммаДопРасходов",, Отказ);
	КонецЕсли;
	
	// Проверка заполнения колонок Количество и Сумма
	Если Объект.СпособРаспределения = ПредопределенноеЗначение("Перечисление.СпособыРаспределенияДопРасходов.ПоКоличеству") Тогда 
		Для Каждого СтрокаТабличнойЧасти Из Объект.Товары Цикл 
			Если СтрокаТабличнойЧасти.Количество = 0 Тогда 
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнено количество в строке №%1.'"), СтрокаТабличнойЧасти.НомерСтроки);
				ПолеСообщения = СтрШаблон("Объект.Товары[%1].Количество", СтрокаТабличнойЧасти.НомерСтроки-1);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,ПолеСообщения,,Отказ);		
			КонецЕсли;	
		КонецЦикла;	
	ИначеЕсли Объект.СпособРаспределения = ПредопределенноеЗначение("Перечисление.СпособыРаспределенияДопРасходов.ПоСумме") Тогда
		Для Каждого СтрокаТабличнойЧасти Из Объект.Товары Цикл 
			Если СтрокаТабличнойЧасти.Сумма = 0 Тогда 
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнена сумма в строке №%1.'"), СтрокаТабличнойЧасти.НомерСтроки);
				ПолеСообщения = СтрШаблон("Объект.Товары[%1].Сумма", СтрокаТабличнойЧасти.НомерСтроки-1);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,ПолеСообщения,,Отказ);		
			КонецЕсли;	
		КонецЦикла;	
		Для Каждого СтрокаТабличнойЧасти Из Объект.ОС Цикл 
			Если СтрокаТабличнойЧасти.Сумма = 0 Тогда 
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнена сумма в строке №%1.'"), СтрокаТабличнойЧасти.НомерСтроки);
				ПолеСообщения = СтрШаблон("Объект.ОС[%1].Сумма", СтрокаТабличнойЧасти.НомерСтроки-1);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,ПолеСообщения,,Отказ);		
			КонецЕсли;	
		КонецЦикла;	
	КонецЕсли;	
		
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросРаспределитьРасходы", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Сумма расходов будет распределена. Продолжить выполнение операции?'");
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);	
КонецПроцедуры // РаспределитьРасходы()

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросРаспределитьРасходы(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		РаспределитьРасходыНаСервере();
	КонецЕсли; 
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Если Объект.ПризнакСтраны = Перечисления.ПризнакиСтраны.ЕАЭС Тогда
		Элементы.БезналичныйРасчет.Видимость = Ложь;
		
		Элементы.ЗначениеСтавкиНДС.Видимость = Ложь;
		Элементы.ЗначениеСтавкиНСП.Видимость = Ложь;
		Элементы.СуммаНДС.Видимость = Ложь;
		Элементы.СуммаНСП.Видимость = Ложь;
		Элементы.ЗачетНДС.Видимость = Ложь;
		
		Элементы.ТоварыСуммаРасходовНДС.Видимость 	= Ложь;
		Элементы.ОССуммаРасходовНДС.Видимость 		= Ложь;
		
		Элементы.СерияБланкаСФ.Видимость 		= Ложь;
		Элементы.НомерБланкаСФ.Видимость 		= Ложь;
		Элементы.ДатаСФ.Видимость 				= Ложь;
		Элементы.НеВключатьВРеестрСФ.Видимость 	= Ложь;
		
	ИначеЕсли Объект.ПризнакСтраны = Перечисления.ПризнакиСтраны.ИмпортЭкспорт Тогда
		Элементы.БезналичныйРасчет.Видимость = Ложь;
		
		Элементы.ЗначениеСтавкиНДС.Видимость = Ложь;
		Элементы.ЗначениеСтавкиНСП.Видимость = Ложь;
		Элементы.СуммаНДС.Видимость = Ложь;
		Элементы.СуммаНСП.Видимость = Ложь;
		Элементы.ЗачетНДС.Видимость = Ложь;
		
		Элементы.ТоварыСуммаРасходовНДС.Видимость 	= Ложь;
		Элементы.ОССуммаРасходовНДС.Видимость 		= Ложь;
		
		Элементы.СерияБланкаСФ.Видимость 		= Ложь;
		Элементы.НомерБланкаСФ.Видимость 		= Ложь;
		Элементы.ДатаСФ.Видимость 				= Ложь;
		Элементы.НеВключатьВРеестрСФ.Видимость 	= Ложь;
		
	Иначе // КР или не заполнен Контрагент	
		Элементы.БезналичныйРасчет.Видимость = ДанныеУчетнойПолитики.ПлательщикНСП;
		
		Элементы.ЗначениеСтавкиНДС.Видимость = ДанныеУчетнойПолитики.ПлательщикНДС;
		Элементы.ЗначениеСтавкиНСП.Видимость = НЕ Объект.БезналичныйРасчет И ДанныеУчетнойПолитики.ПлательщикНСП;
		Элементы.СуммаНДС.Видимость = ДанныеУчетнойПолитики.ПлательщикНДС;
		Элементы.СуммаНСП.Видимость = НЕ Объект.БезналичныйРасчет И ДанныеУчетнойПолитики.ПлательщикНСП;
		Элементы.ЗачетНДС.Видимость = ДанныеУчетнойПолитики.УказыватьПризнакЗачетаНДСПриПоступлении И ДанныеУчетнойПолитики.ПлательщикНДС;
		
		Элементы.ТоварыСуммаРасходовНДС.Видимость 	= ДанныеУчетнойПолитики.ПлательщикНДС;
		Элементы.ОССуммаРасходовНДС.Видимость 		= ДанныеУчетнойПолитики.ПлательщикНСП;
		
		Элементы.СерияБланкаСФ.Видимость 		= ДанныеУчетнойПолитики.ПлательщикНДС;
		Элементы.НомерБланкаСФ.Видимость 		= ДанныеУчетнойПолитики.ПлательщикНДС;
		Элементы.ДатаСФ.Видимость 				= ДанныеУчетнойПолитики.ПлательщикНДС;
		Элементы.НеВключатьВРеестрСФ.Видимость 	= ДанныеУчетнойПолитики.ПлательщикНДС;
	КонецЕсли;	
	
	Если Объект.НеВключатьВРеестрСФ Тогда
		Элементы.СерияБланкаСФ.Доступность 	= Ложь;
		Элементы.НомерБланкаСФ.Доступность 	= Ложь;
		Элементы.ДатаСФ.Доступность			= Ложь;
	Иначе
		Элементы.СерияБланкаСФ.Доступность 	= Истина;
		Элементы.НомерБланкаСФ.Доступность 	= Истина;
		Элементы.ДатаСФ.Доступность			= Истина;
	КонецЕсли;
КонецПроцедуры 

// Процедура устанавливает текущую страницу при открытии формы.
//
&НаКлиенте
Процедура УстановитьТекущуюСтраницу()	
	Если Объект.Товары.Количество() > 0 Тогда 
		Возврат;
	ИначеЕсли Объект.ОС.Количество() > 0 Тогда 
		Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.СтраницаОС;
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
		"ПризнакСтраны",
		Контрагент.ПризнакСтраны);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеКонтрагентПриИзменении()

// Получает набор данных с сервера для процедуры ДоговорКонтрагентаПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеДоговорПриИзменении(Период, ВалютаДокумента, ДоговорКонтрагента)
	
	СтруктураДанные = Новый Структура;
	
	СтруктураДанные.Вставить(
		"ВалютаРасчетов",
		ДоговорКонтрагента.ВалютаРасчетов);
	
	СтруктураДанные.Вставить(
		"ВалютаРасчетовКурсКратность",
		РаботаСКурсамиВалют.ПолучитьКурсВалюты(ДоговорКонтрагента.ВалютаРасчетов, Период));
	
	СтруктураДанные.Вставить(
		"СуммаВключаетНалоги",
		ДоговорКонтрагента.СуммаВключаетНалоги);
	
	СчетаУчета = БухгалтерскийУчетСервер.ПолучитьСчетаРасчетовСКонтрагентом(ДоговорКонтрагента.Организация, ДоговорКонтрагента.Владелец, ДоговорКонтрагента);
	СтруктураДанные.Вставить(
		"СчетРасчетов",
		СчетаУчета.СчетРасчетовПоставщика);
		
	ЗначенияСтавокНДСиНСП = УчетНДСВызовСервера.ПолучитьЗначенияСтавокНДСиНСП(Период, ДоговорКонтрагента); 
	
	СтруктураДанные.Вставить(
		"ЗначениеСтавкиНДС",
		ЗначенияСтавокНДСиНСП.ЗначениеСтавкиНДС);
		
	СтруктураДанные.Вставить(
		"ЗначениеСтавкиНСП",
		ЗначенияСтавокНДСиНСП.ЗначениеСтавкиНСП);
		
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДоговорКонтрагентаПриИзменении()

// Получает ДоговорКонтрагента по умолчанить в зависимости от способа ведения расчетов.
//
&НаСервереБезКонтекста
Функция ПолучитьДоговорПоУмолчанию(Документ, Контрагент, Организация)
	
	МенеджерСправочника = Справочники.ДоговорыКонтрагентов;
	
	СписокВидовДоговоров = МенеджерСправочника.ПолучитьСписокВидовДоговораДляДокумента(Документ);
	ДоговорКонтрагентаПоУмолчанию = МенеджерСправочника.ПолучитьДоговорПоУмолчаниюПоОрганизацииВидуДоговора(Контрагент, Организация, СписокВидовДоговоров);
	
	Возврат ДоговорКонтрагентаПоУмолчанию;
	
КонецФункции

// Выполняет действия при изменении договора контрагента.
//
&НаКлиенте
Процедура ОбработатьИзменениеДоговора(МодифицированДоговор = Ложь)
	
	СтруктураДанные = ПолучитьДанныеДоговорПриИзменении(ДатаДокумента, Объект.ВалютаДокумента, Объект.ДоговорКонтрагента);

	// Обработка изменения валюты
	СтруктураКурсыПред = Новый Структура("Валюта, Курс, Кратность", Объект.ВалютаДокумента, Объект.Курс, Объект.Кратность);
	
	Объект.ВалютаДокумента = СтруктураДанные.ВалютаРасчетов;
	Объект.Курс      = ?(СтруктураДанные.ВалютаРасчетовКурсКратность.Курс = 0, 1, СтруктураДанные.ВалютаРасчетовКурсКратность.Курс);
	Объект.Кратность = ?(СтруктураДанные.ВалютаРасчетовКурсКратность.Кратность = 0, 1, СтруктураДанные.ВалютаРасчетовКурсКратность.Кратность);
	
	СтруктураКурсы = Новый Структура("Валюта, Курс, Кратность", Объект.ВалютаДокумента, Объект.Курс, Объект.Кратность);
	
	// Обработка изменения налогооблажения
	Объект.СуммаВключаетНалоги = СтруктураДанные.СуммаВключаетНалоги;
	
	Если ДанныеУчетнойПолитики.ПлательщикНДС Тогда
		Объект.ЗначениеСтавкиНДС = СтруктураДанные.ЗначениеСтавкиНДС;
	Иначе
		Объект.ЗначениеСтавкиНДС = 0;		
	КонецЕсли;
	
	Если ДанныеУчетнойПолитики.ПлательщикНСП Тогда
		Объект.ЗначениеСтавкиНСП = СтруктураДанные.ЗначениеСтавкиНСП;
	Иначе
		Объект.ЗначениеСтавкиНСП = 0;		
	КонецЕсли;
	
	// Обработка изменения отражения в учете
	Объект.СчетРасчетов = СтруктураДанные.СчетРасчетов;
	
	СтранаВходитВЕАЭС = Объект.ПризнакСтраны = ПредопределенноеЗначение("Перечисление.ПризнакиСтраны.ЕАЭС");
	
	РассчитатьСуммыНалогов();
КонецПроцедуры

// Процедура - Распределить расходы
//
&НаСервере
Процедура РаспределитьРасходыНаСервере()
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.РаспределитьРасходы();
	ЗначениеВРеквизитФормы(Документ, "Объект");	
	Модифицированность = Истина;
	
КонецПроцедуры // РаспределитьТабЧастьРасходыПоКоличеству()

// Процедура - Заполнить по документам основаниям
//
// Параметры:
//  МассивДокументов - Массив	 - массив ссылок на документы поступления
//
&НаСервере
Процедура ЗаполнитьПоДокументамОснованиям(МассивДокументов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоступлениеТоваровУслугТовары.Ссылка КАК ДокументПоступления,
		|	ПоступлениеТоваровУслугТовары.Номенклатура,
		|	ПоступлениеТоваровУслугТовары.Количество,
		|	ПоступлениеТоваровУслугТовары.Всего КАК Сумма,
		|	ПоступлениеТоваровУслугТовары.СчетУчета
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
		|ГДЕ
		|	ПоступлениеТоваровУслугТовары.Ссылка В(&МассивДокументов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПоступлениеТоваровУслугОС.Ссылка КАК ДокументПоступления,
		|	ПоступлениеТоваровУслугОС.ОсновноеСредство,
		|	1 КАК Количество,
		|	ПоступлениеТоваровУслугОС.Всего КАК Сумма,
		|	ПоступлениеТоваровУслугОС.СчетУчета
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.ОС КАК ПоступлениеТоваровУслугОС
		|ГДЕ
		|	ПоступлениеТоваровУслугОС.Ссылка В(&МассивДокументов)";
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	МассивРезультатовЗапроса = Запрос.ВыполнитьПакет();
	
	Объект.Товары.Загрузить(МассивРезультатовЗапроса[0].Выгрузить());
	Объект.ОС.Загрузить(МассивРезультатовЗапроса[1].Выгрузить());
	
КонецПроцедуры 

// Процедура - Добавить строки табличной части из документов поступления
//
// Параметры:
//  МассивДокументов - Массив	 - массив ссылок на документы поступления
//
&НаСервере
Процедура ДобавитьСтрокиТабличнойЧастиИзДокументаПоступления(МассивДокументов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоступлениеТоваровУслугТовары.Ссылка КАК ДокументПоступления,
		|	ПоступлениеТоваровУслугТовары.Номенклатура,
		|	ПоступлениеТоваровУслугТовары.Количество,
		|	ПоступлениеТоваровУслугТовары.Всего КАК Сумма,
		|	ПоступлениеТоваровУслугТовары.СчетУчета
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
		|ГДЕ
		|	ПоступлениеТоваровУслугТовары.Ссылка В(&МассивДокументов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПоступлениеТоваровУслугОС.Ссылка КАК ДокументПоступления,
		|	ПоступлениеТоваровУслугОС.ОсновноеСредство,
		|	1 КАК Количество,
		|	ПоступлениеТоваровУслугОС.Всего КАК Сумма,
		|	ПоступлениеТоваровУслугОС.СчетУчета
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.ОС КАК ПоступлениеТоваровУслугОС
		|ГДЕ
		|	ПоступлениеТоваровУслугОС.Ссылка В(&МассивДокументов)";
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	МассивРезультатовЗапроса = Запрос.ВыполнитьПакет();
	
	// Обход строк Поступления
	СтруктураОтбора = Новый Структура();
	Выборка = МассивРезультатовЗапроса[0].Выбрать(); 
	
	Пока Выборка.Следующий() Цикл
		
		// Поиск текущей позиции основания в табличной части документа возврата.
		// Если найден - увеличение количества; не найден - добавление новой строки.
		СтруктураОтбора.Вставить("Номенклатура", Выборка.Номенклатура);
		
		СтрокаТабличнойЧасти = ОбработкаТабличныхЧастейКлиентСервер.НайтиСтрокуТабличнойЧасти(Объект, "Товары", СтруктураОтбора);
		Если СтрокаТабличнойЧасти <> неопределено Тогда
			
			// Найдена, увеличение количества в первой найденной строке.
			СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество + Выборка.Количество;
			СтрокаТабличнойЧасти.Сумма 		= СтрокаТабличнойЧасти.Сумма + Выборка.Сумма;

		Иначе
			// Не Найдена - добавление новой строки.
			СтрокаТабличнойЧасти = Объект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Выборка);
		КонецЕсли;

	КонецЦикла;
	
	СтруктураОтбора = Новый Структура();	
	Выборка = МассивРезультатовЗапроса[1].Выбрать(); 
	Пока Выборка.Следующий() Цикл
		
		// Поиск текущей позиции основания в табличной части документа возврата.
		// Если найден - увеличение количества; не найден - добавление новой строки.
		СтруктураОтбора.Вставить("ОсновноеСредство", Выборка.ОсновноеСредство);
		
		СтрокаТабличнойЧасти = ОбработкаТабличныхЧастейКлиентСервер.НайтиСтрокуТабличнойЧасти(Объект, "ОС", СтруктураОтбора);
		Если СтрокаТабличнойЧасти <> неопределено Тогда
			 Продолжить;
		Иначе
			// Не Найдена - добавление новой строки.
			СтрокаТабличнойЧасти = Объект.ОС.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Выборка);
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры 

&НаКлиенте
Процедура РассчитатьСуммыНалогов()

	Объект.СуммаНДС = Объект.СуммаДопРасходов * Объект.ЗначениеСтавкиНДС / (100 + Объект.ЗначениеСтавкиНДС + Объект.ЗначениеСтавкиНСП);
	Объект.СуммаНСП = Объект.СуммаДопРасходов * Объект.ЗначениеСтавкиНСП / (100 + Объект.ЗначениеСтавкиНДС + Объект.ЗначениеСтавкиНСП);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеУчетнойПолитики()
	ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиОрганизаций(ДатаДокумента, Объект.Организация);
	
	Если НЕ ДанныеУчетнойПолитики.ПлательщикНДС Тогда
		Объект.СерияБланкаСФ = "";
		Объект.НомерБланкаСФ = "";
		Объект.ДатаСФ = Дата(0001,01,01);
		Объект.НеВключатьВРеестрСФ = Ложь;
	КонецЕсли;	
		
	УстановитьВидимостьДоступностьЭлементов();
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
