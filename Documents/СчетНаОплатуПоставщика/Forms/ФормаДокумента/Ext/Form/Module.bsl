﻿
#Область ОбработчикиСобытийФормы

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
	ТипЦен = Объект.ДоговорКонтрагента.ТипЦен;	
	
	УстановитьФункциональныеОпцииФормы();

	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	// КопированиеСтрокТабличныхЧастей
	КопированиеТабличнойЧастиСервер.ПриСозданииНаСевере(Элементы, "Товары");
	КопированиеТабличнойЧастиСервер.ПриСозданииНаСевере(Элементы, "Услуги");
	// Конец КопированиеСтрокТабличныхЧастей
	
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
	Если ИмяСобытия = "МодифицированДоговораКонтрагента" Тогда
		ОбработатьИзменениеДоговора(Истина);
		
	ИначеЕсли ИмяСобытия = "ПодборНоменклатурыПроизведен" 
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресЗапасовВХранилище = Параметр;
		ПолучитьТоварыИзХранилища(АдресЗапасовВХранилище, "Товары");
		
		ОбновитьПодвалФормы();
		
	ИначеЕсли ИмяСобытия = "Запись_ПлатежноеПоручениеВходящее"
		Или ИмяСобытия = "Запись_ПриходныйКассовыйОрдер" 
		И ЗначениеЗаполнено(Параметр) 
		И Параметр.ДокументОснование = Объект.Ссылка Тогда 
		
		Объект.ДатаОплаты = Параметр.Дата;
		Если Не Модифицированность Тогда
			Записать();
		КонецЕсли;
		Оповестить("ЗаполнениеДатыОплатыВыполнено");

	Иначе
		ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	
	// КопированиеСтрокТабличныхЧастей
	Если ИмяСобытия = "БуферОбменаТабличнаяЧастьКопированиеСтрок" Тогда
		КопированиеТабличнойЧастиКлиент.ОбработкаОповещения(Элементы, "Товары");
		КопированиеТабличнойЧастиКлиент.ОбработкаОповещения(Элементы, "Услуги");
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

	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
	УстановитьФункциональныеОпцииФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("УстановитьПиктограммуКомментария", 0.1, Истина);
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

// Процедура - обработчик события ПриИзменении флага Безналичный расчет.
//
&НаКлиенте
Процедура БезналичныйРасчетПриИзменении(Элемент)
	
	Если Объект.БезналичныйРасчет Тогда
		Объект.СтавкаНСП = Неопределено;
		Объект.СтавкаНСПУслуги = Неопределено;
		
		Для Каждого СтрокаТабличнойЧасти Из Объект.Товары Цикл		
			СтрокаТабличнойЧасти.СуммаНСП = 0;		
		КонецЦикла;	
		
		Для Каждого СтрокаТабличнойЧасти Из Объект.Услуги Цикл		
			СтрокаТабличнойЧасти.СуммаНСП = 0;		
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Ставка НДС.
//
&НаКлиенте
Процедура СтавкаНДСПриИзменении(Элемент)
	ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьНалогиТабличнойЧасти(
		Объект,
		ДатаДокумента,
		Объект.Организация,
		"Товары",
		Объект.СуммаВключаетНалоги, 
		Объект.СтавкаНДС, 
		Объект.СтавкаНСП);
		
	ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьНалогиТабличнойЧасти(
		Объект,
		ДатаДокумента,
		Объект.Организация,
		"Услуги",
		Объект.СуммаВключаетНалоги, 
		Объект.СтавкаНДС, 
		Объект.СтавкаНСПУслуги);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Ставка НСП.
//
&НаКлиенте
Процедура СтавкаНСППриИзменении(Элемент)
	ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьНалогиТабличнойЧасти(
		Объект,
		ДатаДокумента,
		Объект.Организация,
		"Товары",
		Объект.СуммаВключаетНалоги, 
		Объект.СтавкаНДС, 
		Объект.СтавкаНСП);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Ставка НСП для Услуг.
//
&НаКлиенте
Процедура СтавкаНСПУслугиПриИзменении(Элемент)
	ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьНалогиТабличнойЧасти(
		Объект,
		ДатаДокумента,
		Объект.Организация,
		"Услуги",
		Объект.СуммаВключаетНалоги, 
		Объект.СтавкаНДС, 
		Объект.СтавкаНСПУслуги);
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

// Процедура - обработчик события ПередНачаломДобавления таблицы Товары.
//
&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Копирование Тогда 
		ИтогВсего = Объект.Товары.Итог("Всего") + Объект.Услуги.Итог("Всего") + Элемент.ТекущиеДанные.Всего;
		ИтогСуммаНДС = Объект.Товары.Итог("СуммаНДС") + Объект.Услуги.Итог("СуммаНДС") + Элемент.ТекущиеДанные.СуммаНДС;
		ИтогСуммаНСП = Объект.Товары.Итог("СуммаНСП") + Объект.Услуги.Итог("СуммаНСП") + Элемент.ТекущиеДанные.СуммаНСП;
	КонецЕсли;	
КонецПроцедуры

// Процедура - обработчик события ПослеУдаления таблицы Товары.
//
&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Номенклатура.
//
&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	ОбработатьИзменениеНоменклатуры(СтрокаТабличнойЧасти, "Товары");	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Количество.
//
&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммыНалоговСтрокиТабличнойЧасти(
		СтрокаТабличнойЧасти, ДатаДокумента, Объект.Организация, Объект.СуммаВключаетНалоги, Объект.СтавкаНДС, Объект.СтавкаНСП);
	
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ТоварыЦена.
//
&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммыНалоговСтрокиТабличнойЧасти(
		СтрокаТабличнойЧасти, ДатаДокумента, Объект.Организация, Объект.СуммаВключаетНалоги, Объект.СтавкаНДС, Объект.СтавкаНСП);
	
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Сумма.
//
&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьЦенуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммыНалоговСтрокиТабличнойЧасти(
		СтрокаТабличнойЧасти, ДатаДокумента, Объект.Организация, Объект.СуммаВключаетНалоги, Объект.СтавкаНДС, Объект.СтавкаНСП);
	
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода СуммаНДС.
//
&НаКлиенте
Процедура ТоварыСуммаНДСПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(Объект.СуммаВключаетНалоги, 0, СтрокаТабличнойЧасти.СуммаНДС + СтрокаТабличнойЧасти.СуммаНСП);	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ТоварыСуммаНСП.
//
&НаКлиенте
Процедура ТоварыСуммаНСППриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(Объект.СуммаВключаетНалоги, 0, СтрокаТабличнойЧасти.СуммаНДС + СтрокаТабличнойЧасти.СуммаНСП);	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУслуги

// Процедура - обработчик события ПередНачаломДобавления таблицы Услуги.
//
&НаКлиенте
Процедура УслугиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Копирование Тогда 
		ИтогВсего = Объект.Товары.Итог("Всего") + Объект.Услуги.Итог("Всего") + Элемент.ТекущиеДанные.Всего;
		ИтогСуммаНДС = Объект.Товары.Итог("СуммаНДС") + Объект.Услуги.Итог("СуммаНДС") + Элемент.ТекущиеДанные.СуммаНДС;
		ИтогСуммаНСП = Объект.Товары.Итог("СуммаНСП") + Объект.Услуги.Итог("СуммаНСП") + Элемент.ТекущиеДанные.СуммаНСП;
	КонецЕсли;	
КонецПроцедуры

// Процедура - обработчик события ПослеУдаления таблицы Услуги.
//
&НаКлиенте
Процедура УслугиПослеУдаления(Элемент)
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Номенклатура.
//
&НаКлиенте
Процедура УслугиНоменклатураПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	ОбработатьИзменениеНоменклатуры(СтрокаТабличнойЧасти, "Услуги");	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Количество.
//
&НаКлиенте
Процедура УслугиКоличествоПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммыНалоговСтрокиТабличнойЧасти(
		СтрокаТабличнойЧасти, ДатаДокумента, Объект.Организация, Объект.СуммаВключаетНалоги, Объект.СтавкаНДС, Объект.СтавкаНСПУслуги);
	
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода УслугиЦена.
//
&НаКлиенте
Процедура УслугиЦенаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммыНалоговСтрокиТабличнойЧасти(	
		СтрокаТабличнойЧасти, ДатаДокумента, Объект.Организация, Объект.СуммаВключаетНалоги, Объект.СтавкаНДС, Объект.СтавкаНСПУслуги);
	
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Сумма.
//
&НаКлиенте
Процедура УслугиСуммаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьЦенуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммыНалоговСтрокиТабличнойЧасти(
		СтрокаТабличнойЧасти, ДатаДокумента, Объект.Организация, Объект.СуммаВключаетНалоги, Объект.СтавкаНДС, Объект.СтавкаНСПУслуги);
	
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода СуммаНДС.
//
&НаКлиенте
Процедура УслугиСуммаНДСПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(Объект.СуммаВключаетНалоги, 0, СтрокаТабличнойЧасти.СуммаНДС + СтрокаТабличнойЧасти.СуммаНСП);	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода УслугиСуммаНСП.
//
&НаКлиенте
Процедура УслугиСуммаНСППриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(Объект.СуммаВключаетНалоги, 0, СтрокаТабличнойЧасти.СуммаНДС + СтрокаТабличнойЧасти.СуммаНСП);	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик события действия команды Подбор в табличную часть Товары.
// Открывает форму подбора.
//
&НаКлиенте
Процедура ПодборНоменклатуры(Команда)
	РаботаСПодборомНоменклатурыКлиент.ОткрытьПодбор(ЭтаФорма, "Товары", "Реализация");
КонецПроцедуры

// ПодключаемоеОборудование
&НаКлиенте
Процедура ПоискПоШтрихкодуТовары(Команда)
	
	ТекШтрихкод = "";
	ПоказатьВводЗначения(Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", 
		ЭтотОбъект, Новый Структура("ТекШтрихкод, ИмяТабличнойЧасти", ТекШтрихкод, "Товары")), ТекШтрихкод, НСтр("ru = 'Введите штрихкод'"));
		
КонецПроцедуры
	
&НаКлиенте
Процедура ПоискПоШтрихкодуУслуги(Команда)
	
	ТекШтрихкод = "";
	ПоказатьВводЗначения(Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", 
		ЭтотОбъект, Новый Структура("ТекШтрихкод, ИмяТабличнойЧасти", ТекШтрихкод, "Услуги")), ТекШтрихкод, НСтр("ru = 'Введите штрихкод'"));

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

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает текущую страницу при открытии формы.
//
&НаКлиенте
Процедура УстановитьТекущуюСтраницу()	
	Если Объект.Товары.Количество() > 0 Тогда 
		Возврат;
	ИначеЕсли Объект.Услуги.Количество() > 0 Тогда 
		Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.СтраницаУслуги;
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
									|Установить курс расчетов %2ё в соответствии с курсом валюты?'"),
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

// Получает набор данных с сервера для процедуры ДоговорПриИзменении.
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
		"ТипЦен",
		ДоговорКонтрагента.ТипЦен);
	
	СтруктураДанные.Вставить(
		"СуммаВключаетНалоги",
		ДоговорКонтрагента.СуммаВключаетНалоги);
	
	СтруктураДанные.Вставить(
		"СтавкаНДС",
		ДоговорКонтрагента.СтавкаНДС);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДоговорПриИзменении()

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
	Объект.СтавкаНДС = СтруктураДанные.СтавкаНДС;
	
	ТипЦенПередИзменением = ТипЦен;
	ТипЦен = СтруктураДанные.ТипЦен;
	
	// Вопрос изменения
	ИзменилсяТипЦен = ТипЦенПередИзменением <> ТипЦен
		И ЗначениеЗаполнено(ТипЦен);
	ИзмениласьВалютаРасчетов = СтруктураКурсыПред.Валюта <> СтруктураДанные.ВалютаРасчетов
		И ЗначениеЗаполнено(Объект.ВалютаДокумента); 
	ПересчетНеобходим = (Объект.Товары.Количество() > 0)
		Или (Объект.Услуги.Количество() > 0);	
		
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) 
		И (ИзменилсяТипЦен Или ИзмениласьВалютаРасчетов)
		И ПересчетНеобходим Тогда
		
		ТекстСообщение = "";
		
		Если ИзменилсяТипЦен Тогда 
			ТекстСообщение = НСтр("ru = 'Договор с контрагентом предусматривает условия цен, 
				|отличные от установленных в документе! 
				|Возможно, необходимо перезаполнить цены.'") + Символы.ПС + Символы.ПС;
		КонецЕсли;
		
		Если ИзмениласьВалютаРасчетов Тогда 
			ТекстСообщение = ТекстСообщение + НСтр("ru = 'Изменилась валюта расчетов по договору с контрагентом!
				|Возможно, необходимо перезаполнить цены.'") + Символы.ПС + Символы.ПС;
		КонецЕсли;

		ТекстСообщение = ТекстСообщение + НСтр("ru = 'Пересчитать документ в соответствии с договором?'");
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ОбработатьИзменениеДоговораФрагментЗавершение", ЭтотОбъект, 
		
		Новый Структура("СтруктураКурсыПред, СтруктураКурсы", СтруктураКурсыПред, СтруктураКурсы)), 
			ТекстСообщение,
			РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;	
		
	// Пересчет табличной части
	// Цена, Сумма
	ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьЦеныТабличнойЧастиПоВалюте(Объект, ДатаДокумента, СтруктураКурсыПред, СтруктураКурсы, "Товары");
	ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьЦеныТабличнойЧастиПоВалюте(Объект, ДатаДокумента, СтруктураКурсыПред, СтруктураКурсы, "Услуги");
	// Налоги
	ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьНалогиТабличнойЧасти(
		Объект, ДатаДокумента, Объект.Организация, "Товары", Объект.СуммаВключаетНалоги, Объект.СтавкаНДС, Объект.СтавкаНСП);
	ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьНалогиТабличнойЧасти(
		Объект, ДатаДокумента, Объект.Организация, "Услуги", Объект.СуммаВключаетНалоги, Объект.СтавкаНДС, Объект.СтавкаНСПУслуги);
	
	ОбновитьПодвалФормы();
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеДоговораФрагментЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПоказатьПредупреждение(,"ДЛЯ ЦВС: ЭТОТ ВОПРОС ВРЕМЕННЫЙ- ЕСЛИ НУЖЕН- БУДЕМ ДОБАВЛЯТЬ ВО ВСЕХ ДОКУМЕНТАХ.", 30, "ВНИМАНИЕ");
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СтруктураКурсыПред = ДополнительныеПараметры.СтруктураКурсыПред;
		СтруктураКурсы = ДополнительныеПараметры.СтруктураКурсы;
		
		// Цена, Сумма
		ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьЦеныТабличнойЧастиПоВалюте(Объект, ДатаДокумента, СтруктураКурсыПред, СтруктураКурсы, "Товары");
		ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьЦеныТабличнойЧастиПоВалюте(Объект, ДатаДокумента, СтруктураКурсыПред, СтруктураКурсы, "Услуги");
	КонецЕсли;	
	
	// Налоги
	ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьНалогиТабличнойЧасти(
		Объект, ДатаДокумента, Объект.Организация, "Товары", Объект.СуммаВключаетНалоги, Объект.СтавкаНДС, Объект.СтавкаНСП);
	ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьНалогиТабличнойЧасти(
		Объект, ДатаДокумента, Объект.Организация, "Услуги", Объект.СуммаВключаетНалоги, Объект.СтавкаНДС, Объект.СтавкаНСПУслуги);

	ОбновитьПодвалФормы();
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеНоменклатуры(СтрокаТабличнойЧасти, ИмяТабличнойЧасти)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Дата", ДатаДокумента);
	СтруктураДанные.Вставить("Организация", Объект.Организация);
	СтруктураДанные.Вставить("Контрагент", Объект.Контрагент);
	СтруктураДанные.Вставить("ДоговорКонтрагента", Объект.ДоговорКонтрагента);
	СтруктураДанные.Вставить("ВалютаДокумента", Объект.ВалютаДокумента);
	СтруктураДанные.Вставить("СуммаВключаетНалоги", Объект.СуммаВключаетНалоги);
	СтруктураДанные.Вставить("СтавкаНДС", Объект.СтавкаНДС);
	СтруктураДанные.Вставить("СтавкаНСП", ?(ИмяТабличнойЧасти = "Товары", Объект.СтавкаНСП, Объект.СтавкаНСПУслуги));
	СтруктураДанные.Вставить("Номенклатура", СтрокаТабличнойЧасти.Номенклатура);
	
	СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);

	// Заполнение по данным номенклатуры
	СтрокаТабличнойЧасти.Цена = СтруктураДанные.Цена;
	
	// Расчет суммы
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
		
	Если ИмяТабличнойЧасти = "Товары" Тогда 
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммыНалоговСтрокиТабличнойЧасти(
			СтрокаТабличнойЧасти, ДатаДокумента, Объект.Организация, Объект.СуммаВключаетНалоги, Объект.СтавкаНДС, Объект.СтавкаНСП);
	ИначеЕсли ИмяТабличнойЧасти = "Услуги" Тогда 
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммыНалоговСтрокиТабличнойЧасти(
			СтрокаТабличнойЧасти, ДатаДокумента, Объект.Организация, Объект.СуммаВключаетНалоги, Объект.СтавкаНДС, Объект.СтавкаНСПУслуги);
	КонецЕсли;
		
	ОбновитьПодвалФормы();
КонецПроцедуры	

// Получает набор данных с сервера для процедуры НоменклатураПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные)
	
	// Данные номенклатуры
	СтруктураДанные.Вставить("ЕдиницаИзмерения", СтруктураДанные.Номенклатура.ЕдиницаИзмерения);
	СтруктураДанные.Вставить("ЭтоУслуга", СтруктураДанные.Номенклатура.Услуга);
	
	// Счета учета
	СчетаУчетаНоменклатуры = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСчетаУчетаНоменклатуры(СтруктураДанные.Организация, СтруктураДанные.Номенклатура);
	СтруктураДанные.Вставить("СчетУчета", СчетаУчетаНоменклатуры.СчетУчета);
	
	// Цены 
	СтруктураДанные.Вставить("ТипЦен", СтруктураДанные.ДоговорКонтрагента.ТипЦен);
	Цена = БухгалтерскийУчетСервер.ПолучитьЦенуНоменклатуры(СтруктураДанные);
	СтруктураДанные.Вставить("Цена", Цена);
		
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеНоменклатураПриИзменении()

// Процедура рассчитывает итоги для подвала формы.
//
&НаКлиенте
Процедура ОбновитьПодвалФормы()
	
	ИтогВсего = Объект.Товары.Итог("Всего") + Объект.Услуги.Итог("Всего");
	ИтогСуммаНДС = Объект.Товары.Итог("СуммаНДС") + Объект.Услуги.Итог("СуммаНДС");
	ИтогСуммаНСП = Объект.Товары.Итог("СуммаНСП") + Объект.Услуги.Итог("СуммаНСП");
	
КонецПроцедуры // ОбновитьПодвалФормы()

// Процедура - обработчик подбора товаров.
//
&НаСервере
Процедура ПолучитьТоварыИзХранилища(АдресЗапасовВХранилище, ИмяТабличнойЧасти)
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	Для Каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		НайденныеСтроки = Объект.Товары.НайтиСтроки(Новый Структура("Номенклатура", СтрокаЗагрузки.Номенклатура));
		
		Если НайденныеСтроки.Количество() > 0 Тогда 
			Продолжить;
		КонецЕсли;	
		
		СтрокаТабличнойЧасти = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаЗагрузки);
		
		// Расчет суммы
		СтавкаНСП = Объект.СтавкаНСП;
		
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);	
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммыНалоговСтрокиТабличнойЧасти(
			СтрокаТабличнойЧасти, ДатаДокумента, Объект.Организация, Объект.СуммаВключаетНалоги, Объект.СтавкаНДС, СтавкаНСП);
	КонецЦикла;
КонецПроцедуры // ПолучитьТоварыИзХранилища()

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

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
			СтрокаСообщения = СтрШаблон(НСтр("ru = 'Данные по штрихкоду не найдены: %1'"), СтруктураДанные.ТекШтрихкод);
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
		ИначеЕсли ИмяТабличнойЧасти = "Товары"
			И СтруктураДанные.ТипНоменклатурыУслуга Тогда
			ШтрихкодыНекорректногоТипа.Добавить(Новый Структура("ТекШтрихкод, Номенклатура", ТекШтрихкод, СтруктураДанные.Номенклатура));
		ИначеЕсли ИмяТабличнойЧасти = "Услуги"
			И НЕ СтруктураДанные.ТипНоменклатурыУслуга Тогда
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
Процедура УслугиКопироватьСтроки(Команда)
	
	КопироватьСтроки("Услуги");
	
КонецПроцедуры

&НаКлиенте
Процедура УслугиВставитьСтроки(Команда)
	
	ВставитьСтроки("Услуги");
	
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
