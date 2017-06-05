﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ИнтерфейсПечати

Функция ПечатьСчетНаОплату(МассивОбъектов, ОбъектыПечати)
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СчетНаОплатуПокупателю";
	
	ТекстЗапроса =
	
	"ВЫБРАТЬ
	|	СчетНаОплатуПокупателю.Ссылка,
	|	СчетНаОплатуПокупателю.Номер,
	|	СчетНаОплатуПокупателю.Дата,
	|	СчетНаОплатуПокупателю.Организация,
	|	СчетНаОплатуПокупателю.Организация.НаименованиеПолное,
	|	СчетНаОплатуПокупателю.Контрагент,
	|	СчетНаОплатуПокупателю.Контрагент.НаименованиеПолное,
	|	СчетНаОплатуПокупателю.Склад,
	|	СчетНаОплатуПокупателю.ВидСкидки,
	|	СчетНаОплатуПокупателю.Товары.(
	|		Номенклатура.Наименование,
	|		Номенклатура.Код КАК Код,
	|		Номенклатура.ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмеренияНаименование,
	|		Количество,
	|		Цена,
	|		Всего КАК СуммаБезСкидки,
	|		СуммаНДС,
	|		СуммаНСП,
	|		СуммаСкидки КАК Скидка,
	|		Итого КАК Сумма
	|	),
	|	СчетНаОплатуПокупателю.Услуги.(
	|		Номенклатура.Наименование,
	|		Номенклатура.ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмеренияНаименование,
	|		Количество,
	|		Цена,
	|		Всего КАК СуммаБезСкидки,
	|		Итого КАК Сумма,
	|		СуммаНДС,
	|		СуммаНСП,
	|		СуммаСкидки КАК Скидка,
	|		Номенклатура.Код КАК Код
	|	)
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю КАК СчетНаОплатуПокупателю
	|ГДЕ
	|	СчетНаОплатуПокупателю.Ссылка В(&СписокДокументов)";
				
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "СчетНаОплатуПокупателю";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.СчетНаОплатуПокупателю.ПФ_MXL_СчетНаОплату");
		
	Пока Выборка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ДанныеПечати = Новый Структура;
		
		ВременнаяТаблицаТовары = Выборка.Товары.Выгрузить();                                      
		ВременнаяТаблицаУслуги = Выборка.Услуги.Выгрузить();
		
		ТекстЗаголовка = "Счет на оплату № " + ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Выборка.Номер)
		               + " от "+Формат(Выборка.Дата,"ДЛФ=DD");
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеПечати.Вставить("ПредставлениеПоставщика", Выборка.ОрганизацияНаименованиеПолное);
		ДанныеПечати.Вставить("Склад", Выборка.Склад);
		ДанныеПечати.Вставить("ПредставлениеПолучателя", Выборка.КонтрагентНаименованиеПолное);

		ДанныеПечати.Вставить("Всего", 	ВременнаяТаблицаТовары.Итог("Сумма") + ВременнаяТаблицаУслуги.Итог("Сумма"));
		ДанныеПечати.Вставить("ВсегоНДС", ВременнаяТаблицаТовары.Итог("СуммаНДС") + ВременнаяТаблицаУслуги.Итог("СуммаНДС"));
		ДанныеПечати.Вставить("ВсегоНСП", ВременнаяТаблицаТовары.Итог("СуммаНСП") + ВременнаяТаблицаУслуги.Итог("СуммаНСП"));
		ДанныеПечати.Вставить("Скидка", ВременнаяТаблицаТовары.Итог("Скидка") + ВременнаяТаблицаУслуги.Итог("Скидка"));
			
		МассивОбластейМакета = Новый Массив;  
		МассивОбластейМакета.Добавить("Заголовок");
		МассивОбластейМакета.Добавить("Поставщик");
		МассивОбластейМакета.Добавить("Покупатель");

		Если ЗначениеЗаполнено(Выборка.ВидСкидки) Тогда 
			МассивОбластейМакета.Добавить("ШапкаТаблицыСоСкидкой"); 
		Иначе
			МассивОбластейМакета.Добавить("ШапкаТаблицы");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ВидСкидки) Тогда 
			МассивОбластейМакета.Добавить("СтрокаСоСкидкой"); 
		Иначе
			МассивОбластейМакета.Добавить("Строка");
		КонецЕсли;

		МассивОбластейМакета.Добавить("Итого");
		МассивОбластейМакета.Добавить("ИтогоНДС");      
	    МассивОбластейМакета.Добавить("ИтогоНСП");
		
		Если ЗначениеЗаполнено(Выборка.ВидСкидки) Тогда 
			МассивОбластейМакета.Добавить("ИтогоСкидка");
			Скидка = ВременнаяТаблицаТовары.Итог("Скидка");
  		КонецЕсли;
        		
		ИтоговаяСтрока="Всего наименований "+ (ВременнаяТаблицаТовары.Количество() + ВременнаяТаблицаУслуги.Количество()) +", на сумму "+ВременнаяТаблицаТовары.Итог("Сумма");
		ДанныеПечати.Вставить("ИтоговаяСтрока", ИтоговаяСтрока);
        ДанныеПечати.Вставить("СуммаПрописью", БухгалтерскийУчетСервер.СформироватьСуммуПрописью(ДанныеПечати.Всего));

	    МассивОбластейМакета.Добавить("СуммаПрописью");
        МассивОбластейМакета.Добавить("Подписи");

		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			
			Если НЕ (ИмяОбласти = "Строка" Или ИмяОбласти = "СтрокаСоСкидкой") Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			Иначе				
				НомерСтроки = 1;
				Для Каждого СтрокаТабличнойЧасти Из ВременнаяТаблицаТовары Цикл 
					ОбластьМакета.Параметры.Заполнить(СтрокаТабличнойЧасти);
					ОбластьМакета.Параметры.НомерСтроки = НомерСтроки;
					НомерСтроки = НомерСтроки + 1;
					ТабличныйДокумент.Вывести(ОбластьМакета);					
				КонецЦикла;
				Для Каждого СтрокаТабличнойЧасти Из ВременнаяТаблицаУслуги Цикл 
					ОбластьМакета.Параметры.Заполнить(СтрокаТабличнойЧасти);
					ОбластьМакета.Параметры.НомерСтроки = НомерСтроки;
					НомерСтроки = НомерСтроки + 1;
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;					
			КонецЕсли;
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб=Истина;
	ТабличныйДокумент.ОриентацияСтраницы= ОриентацияСтраницы.Портрет;
	
	Возврат ТабличныйДокумент;
	
КонецФункции
	
// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СчетНаОплату") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"СчетНаОплату", НСтр("ru = Счет на оплату покупателю'"), ПечатьСчетНаОплату(МассивОбъектов, ОбъектыПечати),,
		"Документ.СчетНаОплатуПокупателю.ПФ_MXL_СчетНаОплату");
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СчетНаОплату";
	КомандаПечати.Представление = НСтр("ru = 'Счет на оплату покупателю'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли