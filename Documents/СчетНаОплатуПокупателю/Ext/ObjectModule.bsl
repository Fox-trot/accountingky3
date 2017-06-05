﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	СуммаДокумента = Товары.Итог("Итого") + Услуги.Итог("Итого");
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоРеализацииТоваровУслуг(ДанныеЗаполнения) Экспорт
	
	ДокументОснование = ДанныеЗаполнения;
	
	// Шапка
	Организация			= ДанныеЗаполнения.Организация;
	ВалютаДокумента     = ДанныеЗаполнения.ВалютаДокумента;
	БанковскийСчет      = ДанныеЗаполнения.Контрагент.ОсновнойБанковскийСчет;
	Контрагент          = ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента  = ДанныеЗаполнения.ДоговорКонтрагента;
	Склад			    = ДанныеЗаполнения.Склад;
	СуммаДокумента      = ДанныеЗаполнения.СуммаДокумента;
	СуммаНДС            = ДанныеЗаполнения.Товары.Итог("СуммаНДС");
	СуммаНСП            = ДанныеЗаполнения.Товары.Итог("СуммаНСП");
	ВидСкидки  			= ДанныеЗаполнения.ВидСкидки;
	СкидкаПроцент       = ДанныеЗаполнения.СкидкаПроцент;
	СуммаСкидки         = ДанныеЗаполнения.СуммаСкидки;
	
	// Заполнение ТЧ "Товары"
	Для каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Товары Цикл
		НоваяСтрока = Товары.Добавить();	
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТабличнойЧасти);
		НоваяСтрока.Партия = ДанныеЗаполнения;
	КонецЦикла;
	
	// Заполнение ТЧ "Услуги"
	Для каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Услуги Цикл
		НоваяСтрока = Услуги.Добавить();	
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТабличнойЧасти);
	КонецЦикла;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.СчетНаОплатуПокупателю")] = "ЗаполнитьПоСчетуНаОплатуПокупателю";
	СтратегияЗаполнения[Тип("ДокументСсылка.РеализацияТоваровУслуг")] = "ЗаполнитьПоРеализацииТоваровУслуг";
	
	ЗаполнениеОбъектов.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
	ВалютаРегламентированногоУчета 	= ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	ДатаДокумента = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДата());
	Если НЕ ЗначениеЗаполнено(БанковскийСчет) Тогда		
		БанковскийСчет = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьОсновнойБанковскийСчетОрганизации(Организация);		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВалютаДокумента) 
		И ЗначениеЗаполнено(ДоговорКонтрагента)
		И ЗначениеЗаполнено(ДоговорКонтрагента.ВалютаРасчетов)Тогда
		ВалютаДокумента = ДоговорКонтрагента.ВалютаРасчетов;			
	Иначе	
		ВалютаДокумента = ВалютаРегламентированногоУчета;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Курс) Тогда
		Курс = 1;
		Если ЗначениеЗаполнено(ВалютаДокумента) Тогда
			КурсСтруктура	= РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДата()));
			Курс 			= КурсСтруктура.Курс;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли