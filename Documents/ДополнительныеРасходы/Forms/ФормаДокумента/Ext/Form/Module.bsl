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
	
	УстановитьФункциональныеОпцииФормы();
	
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
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
	ОбновитьПодвалФормы();
	
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

	ИначеЕсли ИмяСобытия = "ПодборПоДокументамПроизведен" 
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресДокументовВХранилище = "";
		Параметр.Свойство("АдресДокументовВХранилище", АдресДокументовВХранилище);
		Если ЗначениеЗаполнено(АдресДокументовВХранилище) Тогда
			ПолучитьДокументыИзХранилища(АдресДокументовВХранилище);
		КонецЕсли;
		
		ОбновитьПодвалФормы();
	Иначе
		ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);	
	КонецЕсли;
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
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Объект.Номер = "";
	Объект.БанковскийСчет = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьОсновнойБанковскийСчетОрганизации(Объект.Организация);

	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
	УстановитьФункциональныеОпцииФормы();
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
	Если Объект.ПризнакСтраны = ПредопределенноеЗначение("Перечисление.ПризнакиСтраны.ЕАЭС") Тогда
		Объект.БезналичныйРасчет = Ложь;
		// Ставки
		Объект.ЗначениеСтавкиНСП = Неопределено;
	ИначеЕсли Объект.ПризнакСтраны = ПредопределенноеЗначение("Перечисление.ПризнакиСтраны.ИмпортЭкспорт") Тогда	
		Объект.БезналичныйРасчет = Ложь;
		// Ставки
		Объект.ЗначениеСтавкиНДС = 0;
		Объект.ЗначениеСтавкиНСП = Неопределено;
	КонецЕсли;
	
	ОбработатьИзменениеДоговора();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Договор контрагента.
//
&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	ОбработатьИзменениеДоговора();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Ставка НДС.
//
&НаКлиенте
Процедура ЗначениеСтавкиНДСПриИзменении(Элемент)
	СтранаВходитВЕАЭС = Объект.ПризнакСтраны = ПредопределенноеЗначение("Перечисление.ПризнакиСтраны.ЕАЭС");
		
	ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьНалогиТабличнойЧасти(
		Объект,
		ДатаДокумента,
		Объект.Организация,
		"Расходы",
		Объект.СуммаВключаетНалоги, 
		Объект.ЗначениеСтавкиНДС, 
		Объект.ЗначениеСтавкиНСП,
		?(СтранаВходитВЕАЭС, Истина, Объект.БезналичныйРасчет));
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Ставка НСП.
//
&НаКлиенте
Процедура ЗначениеСтавкиНСППриИзменении(Элемент)
	СтранаВходитВЕАЭС = Объект.ПризнакСтраны = ПредопределенноеЗначение("Перечисление.ПризнакиСтраны.ЕАЭС");
		
	ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьНалогиТабличнойЧасти(
		Объект,
		ДатаДокумента,
		Объект.Организация,
		"Расходы",
		Объект.СуммаВключаетНалоги, 
		Объект.ЗначениеСтавкиНДС, 
		Объект.ЗначениеСтавкиНСП,
		?(СтранаВходитВЕАЭС, Истина, Объект.БезналичныйРасчет));
КонецПроцедуры

// Процедура - обработчик события ПриИзменении флага Безналичный расчет.
//
&НаКлиенте
Процедура БезналичныйРасчетПриИзменении(Элемент)
	
	УстановитьВидимостьДоступностьЭлементов();
	
	СтранаВходитВЕАЭС = Объект.ПризнакСтраны = ПредопределенноеЗначение("Перечисление.ПризнакиСтраны.ЕАЭС");

	ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьНалогиТабличнойЧасти(
		Объект,
		ДатаДокумента,
		Объект.Организация,
		"Расходы",
		Объект.СуммаВключаетНалоги, 
		Объект.ЗначениеСтавкиНДС, 
		Объект.ЗначениеСтавкиНСП,
		?(СтранаВходитВЕАЭС, Истина, Объект.БезналичныйРасчет));

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРасходы

// Процедура - обработчик события ПередНачаломДобавления таблицы Расходы.
//
&НаКлиенте
Процедура РасходыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Копирование Тогда 
		ИтогВсего = Объект.Расходы.Итог("Всего") + Элемент.ТекущиеДанные.Всего;
		ИтогСуммаНДС = Объект.Расходы.Итог("СуммаНДС") + Элемент.ТекущиеДанные.СуммаНДС;
		ИтогСуммаНСП = Объект.Расходы.Итог("СуммаНСП") + Элемент.ТекущиеДанные.СуммаНСП;
	КонецЕсли;	
КонецПроцедуры

// Процедура - обработчик события ПослеУдаления таблицы Расходы.
//
&НаКлиенте
Процедура РасходыПослеУдаления(Элемент)
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода РасходыНоменклатура.
//
&НаКлиенте
Процедура РасходыНоменклатураПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Расходы.ТекущиеДанные;
	СтрокаТабличнойЧасти.Количество = 1;
	
	// Расчет суммы
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммыНалоговСтрокиТабличнойЧасти(
		СтрокаТабличнойЧасти, ДатаДокумента, Объект.Организация, Объект.СуммаВключаетНалоги, Объект.ЗначениеСтавкиНДС, Объект.ЗначениеСтавкиНСП);

	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода РасходыКоличество.
//
&НаКлиенте
Процедура РасходыКоличествоПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Расходы.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммыНалоговСтрокиТабличнойЧасти(
		СтрокаТабличнойЧасти, ДатаДокумента, Объект.Организация, Объект.СуммаВключаетНалоги, Объект.ЗначениеСтавкиНДС, Объект.ЗначениеСтавкиНСП);
	
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода РасходыЦена.
//
&НаКлиенте
Процедура РасходыЦенаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Расходы.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммыНалоговСтрокиТабличнойЧасти(
		СтрокаТабличнойЧасти, ДатаДокумента, Объект.Организация, Объект.СуммаВключаетНалоги, Объект.ЗначениеСтавкиНДС, Объект.ЗначениеСтавкиНСП);
	
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода РасходыСумма.
//
&НаКлиенте
Процедура РасходыСуммаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Расходы.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьЦенуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммыНалоговСтрокиТабличнойЧасти(
		СтрокаТабличнойЧасти, ДатаДокумента, Объект.Организация, Объект.СуммаВключаетНалоги, Объект.ЗначениеСтавкиНДС, Объект.ЗначениеСтавкиНСП);

	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода РасходыСуммаНДС.
//
&НаКлиенте
Процедура РасходыСуммаНДСПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Расходы.ТекущиеДанные;
	СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(Объект.СуммаВключаетНалоги, 0, СтрокаТабличнойЧасти.СуммаНДС + СтрокаТабличнойЧасти.СуммаНСП);	
	
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода РасходыСуммаНСП.
//
&НаКлиенте
Процедура РасходыСуммаНСППриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Расходы.ТекущиеДанные;
	СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(Объект.СуммаВключаетНалоги, 0, СтрокаТабличнойЧасти.СуммаНДС + СтрокаТабличнойЧасти.СуммаНСП);	
	
	ОбновитьПодвалФормы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды командной панели табличной части.
//
&НаКлиенте
Процедура ПодборПоДокументам(Команда)
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("УникальныйИдентификаторФормыВладельца", УникальныйИдентификатор);
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
	
	Если Объект.Расходы.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'В табличной части ""Расходы"" нет записей! Распределение отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Расходы",, Отказ);
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
	ТекстВопроса = НСтр("ru = 'Сумма расходов будет распределена! Продолжить выполнение операции?'");
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
&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Если Объект.ПризнакСтраны = ПредопределенноеЗначение("Перечисление.ПризнакиСтраны.ЕАЭС") Тогда
		Элементы.БезналичныйРасчет.Видимость = Ложь;
		// Ставки
		Элементы.ЗначениеСтавкиНДС.Видимость = Ложь;
		Элементы.ЗначениеСтавкиНСП.Видимость = Ложь;
		
	ИначеЕсли Объект.ПризнакСтраны = ПредопределенноеЗначение("Перечисление.ПризнакиСтраны.ИмпортЭкспорт") Тогда	
		Элементы.БезналичныйРасчет.Видимость = Ложь;
		// Ставки
		Элементы.ЗначениеСтавкиНДС.Видимость = Ложь;
		Элементы.ЗначениеСтавкиНСП.Видимость = Ложь;
	Иначе // КР или не заполнен Контрагент	
		Элементы.БезналичныйРасчет.Видимость = Истина;
		// Ставки
		Элементы.ЗначениеСтавкиНДС.Видимость = Истина;
		
		// Сумма НСП
		Если Объект.БезналичныйРасчет Тогда 
			Элементы.ЗначениеСтавкиНСП.Видимость = Ложь;
		Иначе 
			Элементы.ЗначениеСтавкиНСП.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;	
		
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()    

// Процедура устанавливает текущую страницу при открытии формы.
//
&НаКлиенте
Процедура УстановитьТекущуюСтраницу()	
	Если Объект.Товары.Количество() > 0 Тогда 
		Возврат;
	ИначеЕсли Объект.ОС.Количество() > 0 Тогда 
		Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.СтраницаОС;
	ИначеЕсли Объект.Расходы.Количество() > 0 Тогда 
		Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.СтраницаРасходы;
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
		
		ТекстСообщения = НСтр("ru = 'На дату документа у валюты расчетов (" + КурсВалютыСтрокой + ") был задан курс.
									|Установить курс расчетов (" + КурсНовыйВалютыСтрокой + ") в соответствии с курсом валюты?'");
		
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
	
	// Обработка изменения отражения в учете
	Объект.СчетРасчетов = СтруктураДанные.СчетРасчетов;
	
	СтранаВходитВЕАЭС = Объект.ПризнакСтраны = ПредопределенноеЗначение("Перечисление.ПризнакиСтраны.ЕАЭС");

	// Пересчет табличной части
	// Цена, Сумма
	ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьЦеныТабличнойЧастиПоВалюте(Объект, ДатаДокумента, СтруктураКурсыПред, СтруктураКурсы, "Расходы");
	// Налоги
	ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьНалогиТабличнойЧасти(
		Объект, ДатаДокумента, Объект.Организация, "Расходы", Объект.СуммаВключаетНалоги, Объект.ЗначениеСтавкиНДС, Объект.ЗначениеСтавкиНСП,?(СтранаВходитВЕАЭС, Истина, Объект.БезналичныйРасчет));
	
	ОбновитьПодвалФормы();
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

// Процедура - Заполнить по документам оснований
//
// Параметры:
//  МассивДокументов - Массив - массив ссылок на документы поступления
//
&НаСервере
Процедура ПолучитьДокументыИзХранилища(АдресДокументовВХранилище)
	
	МассивДокументов = ПолучитьИзВременногоХранилища(АдресДокументовВХранилище);

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

// Процедура рассчитывает итоги для подвала формы.
//
&НаКлиенте
Процедура ОбновитьПодвалФормы()
	
	ИтогВсего = Объект.Расходы.Итог("Всего");
	ИтогСуммаНДС = Объект.Расходы.Итог("СуммаНДС");
	ИтогСуммаНСП = Объект.Расходы.Итог("СуммаНСП");
	
КонецПроцедуры // ОбновитьПодвалФормы()

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
