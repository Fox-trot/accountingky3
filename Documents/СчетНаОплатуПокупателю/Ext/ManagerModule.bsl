﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Процедура - Заполнить дату оплаты
//
// Параметры:
//  ДатаОплаты			 	- Дата	 - Дата оплаты
//  СчетНаОплатуПокупателю	- ДокументСсылка.СчетНаОплатуПокупателю - Ссылка на документ счет на оплату для которого нужно заполнить дату оплаты
//
Процедура ЗаполнитьДатуОплаты(ДатаОплаты, СчетНаОплатуПокупателю) Экспорт 
	ДокументОбъект = СчетНаОплатуПокупателю.ПолучитьОбъект();
	ДокументОбъект.ДатаОплаты = ДатаОплаты;
	
	Попытка
		ДокументОбъект.Записать();	
	Исключение
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось завершить запись документа по причине: %1'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
	КонецПопытки;
КонецПроцедуры // ЗаполнитьДатуОплаты()
	
#КонецОбласти
	
#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ИнтерфейсПечати

// Функция формирует табличный документ с печатной формой СчетНаОплату
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьСчетНаОплату(МассивОбъектов, ОбъектыПечати)
	Перем Ошибки, ПервыйДокумент, НомерСтрокиНачало;
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	СчетНаОплатуПокупателю.Ссылка КАК Ссылка,
		|	СчетНаОплатуПокупателю.Номер КАК Номер,
		|	СчетНаОплатуПокупателю.Дата КАК Дата,
		|	СчетНаОплатуПокупателю.ВалютаДокумента КАК ВалютаДокумента,
		|	СчетНаОплатуПокупателю.Организация КАК Организация,
		|	СчетНаОплатуПокупателю.Организация.НаименованиеПолное КАК ОрганизацияПредставление,
		|	СчетНаОплатуПокупателю.Организация.ФайлЛоготип КАК ФайлЛоготип,
		|	СчетНаОплатуПокупателю.Организация.ИНН КАК ОрганизацияИНН,
		|	СчетНаОплатуПокупателю.БанковскийСчет.Банк.Наименование КАК ОрганизацияБанк,
		|	СчетНаОплатуПокупателю.БанковскийСчет.НомерСчета КАК ОрганизацияБанковскийСчет,
		|	СчетНаОплатуПокупателю.БанковскийСчет.Банк.Код КАК ОрганизацияБикБанковскогоСчета,
		|	СчетНаОплатуПокупателю.Контрагент КАК Контрагент,
		|	СчетНаОплатуПокупателю.Контрагент.НаименованиеПолное КАК КонтрагентПредставление,
		|	СчетНаОплатуПокупателю.Контрагент.ИНН КАК КонтрагентИНН,
		|	СчетНаОплатуПокупателю.Контрагент.ОсновнойБанковскийСчет.Банк.Наименование КАК КонтрагентБанк,
		|	СчетНаОплатуПокупателю.Контрагент.ОсновнойБанковскийСчет.НомерСчета КАК КонтрагентБанковскийСчет,
		|	СчетНаОплатуПокупателю.Контрагент.ОсновнойБанковскийСчет.Банк.Код КАК КонтрагентБикБанковскогоСчета,
		|	СчетНаОплатуПокупателю.Комментарий КАК Комментарий,
		|	СчетНаОплатуПокупателю.Товары.(
		|		НомерСтроки КАК НомерСтроки,
		|		Номенклатура КАК Номенклатура,
		|		Номенклатура.НаименованиеПолное КАК НоменклатураПредставление,
		|		ПРЕДСТАВЛЕНИЕ(СчетНаОплатуПокупателю.Товары.Номенклатура.ЕдиницаИзмерения) КАК ЕИ,
		|		Количество КАК Количество,
		|		Цена КАК Цена,
		|		Сумма КАК Сумма,
		|		СуммаНДС КАК СуммаНДС,
		|		СуммаНСП КАК СуммаНСП,
		|		СуммаСкидки КАК СуммаСкидки,
		|		Всего КАК Всего
		|	) КАК Товары,
		|	СчетНаОплатуПокупателю.Услуги.(
		|		НомерСтроки КАК НомерСтроки,
		|		Номенклатура КАК Номенклатура,
		|		Номенклатура.НаименованиеПолное КАК НоменклатураПредставление,
		|		ПРЕДСТАВЛЕНИЕ(СчетНаОплатуПокупателю.Услуги.Номенклатура.ЕдиницаИзмерения) КАК ЕИ,
		|		Количество КАК Количество,
		|		Цена КАК Цена,
		|		Сумма КАК Сумма,
		|		СуммаНДС КАК СуммаНДС,
		|		СуммаНСП КАК СуммаНСП,
		|		СуммаСкидки КАК СуммаСкидки,
		|		Всего КАК Всего
		|	) КАК Услуги
		|ИЗ
		|	Документ.СчетНаОплатуПокупателю КАК СчетНаОплатуПокупателю
		|ГДЕ
		|	СчетНаОплатуПокупателю.Ссылка В(&СписокДокументов)";		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "СчетНаОплатуПокупателю_СчетНаОплату";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.СчетНаОплатуПокупателю.ПФ_MXL_СчетНаОплату");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		
		// Сведения об организации
		АдресОрганизации = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Шапка.Организация, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации, Шапка.Дата); 
		ТелефонОрганизации = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Шапка.Организация, Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации, Шапка.Дата);
		
		ДанныеПечати.Вставить("ОрганизацияПредставление", "" + Шапка.ОрганизацияПредставление 
		+ ?(ЗначениеЗаполнено(Шапка.ОрганизацияИНН),", " + "ИНН " + Шапка.ОрганизацияИНН, "")               
		+ ?(ЗначениеЗаполнено(АдресОрганизации),", " + АдресОрганизации, "")                       
		+ ?(ЗначениеЗаполнено(ТелефонОрганизации),", " + "тел: " + ТелефонОрганизации, "")
		+ ?(ЗначениеЗаполнено(Шапка.ОрганизацияБанковскийСчет),", " + "р/с " + Шапка.ОрганизацияБанковскийСчет, "")
		+ ?(ЗначениеЗаполнено(Шапка.ОрганизацияБанк),", " + Шапка.ОрганизацияБанк, "")
		+ ?(ЗначениеЗаполнено(Шапка.ОрганизацияБикБанковскогоСчета),", " + "БИК " + Шапка.ОрганизацияБикБанковскогоСчета, ""));

		// Сведения о контрагенте
		АдресКонтрагента = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Шапка.Контрагент, Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента); 
		ТелефонКонтрагента = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Шапка.Контрагент, Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента); 
		
		ДанныеПечати.Вставить("ПолучательПредставление", "" + Шапка.КонтрагентПредставление 
		+ ?(ЗначениеЗаполнено(Шапка.КонтрагентИНН),", " + "ИНН " + Шапка.КонтрагентИНН, "") 
		+ ?(ЗначениеЗаполнено(АдресКонтрагента),", " + АдресКонтрагента, "")
		+ ?(ЗначениеЗаполнено(ТелефонКонтрагента),", " + "тел: " + ТелефонКонтрагента, "")
		+ ?(ЗначениеЗаполнено(Шапка.КонтрагентБанковскийСчет),", " + "р/с " + Шапка.КонтрагентБанковскийСчет, "")
		+ ?(ЗначениеЗаполнено(Шапка.КонтрагентБанк),", " + Шапка.КонтрагентБанк, "")
		+ ?(ЗначениеЗаполнено(Шапка.КонтрагентБикБанковскогоСчета),", " + "БИК " + Шапка.КонтрагентБикБанковскогоСчета, ""));		
		
		ТекстЗаголовка = СформироватьЗаголовокДокумента(Шапка, НСтр("ru = 'Счет на оплату'"));
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеПечати.Вставить("ФайлЛоготип", Шапка.ФайлЛоготип);
		ДанныеПечати.Вставить("Комментарий", Шапка.Комментарий);

		ТаблицаТовары = Шапка.Товары.Выгрузить();
		ТаблицаУслуги = Шапка.Услуги.Выгрузить();
		
		Всего = ТаблицаТовары.Итог("Всего") + ТаблицаУслуги.Итог("Всего");
		ВсегоНДС = ТаблицаТовары.Итог("СуммаНДС") + ТаблицаУслуги.Итог("СуммаНДС");
		ВсегоНСП = ТаблицаТовары.Итог("СуммаНСП") + ТаблицаУслуги.Итог("СуммаНСП");
		КоличествоНаименований = ТаблицаТовары.Количество() + ТаблицаУслуги.Количество();		
		
		ВсегоСкидка = ТаблицаТовары.Итог("СуммаСкидки") + ТаблицаУслуги.Итог("СуммаСкидки");
		ЕстьСкидка = ВсегоСкидка <> 0;
		
		ДанныеПечати.Вставить("Всего", Всего);
		ДанныеПечати.Вставить("ВсегоНДС", ВсегоНДС);
		ДанныеПечати.Вставить("ВсегоНСП", ВсегоНСП);
		ДанныеПечати.Вставить("ИтоговаяСтрока", 
			СтрШаблон(НСтр("ru = 'Всего наименований %1, на сумму %2 %3'"), 
						Формат(КоличествоНаименований, "ЧН=0; ЧГ=0"), 
						Формат(ДанныеПечати.Всего, "ЧЦ=15; ЧДЦ=2"),
						Шапка.ВалютаДокумента));
		ДанныеПечати.Вставить("СуммаПрописью", БухгалтерскийУчетСервер.СформироватьСуммуПрописью(ДанныеПечати.Всего, Шапка.ВалютаДокумента));

		// Подписи.
		РасшифровкаПодписиРуководителя = "";
		РасшифровкаПодписиГлавногоБухгалтера = "";
		ОтветственныеЛица = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Шапка.Организация, Шапка.Дата);
		БухгалтерскийУчетСервер.ФамилияИнициалыПоНаименованию(РасшифровкаПодписиРуководителя, ОтветственныеЛица.Руководитель);
		БухгалтерскийУчетСервер.ФамилияИнициалыПоНаименованию(РасшифровкаПодписиГлавногоБухгалтера, ОтветственныеЛица.ГлавныйБухгалтер);
		
		ДанныеПечати.Вставить("РасшифровкаПодписиРуководителя", РасшифровкаПодписиРуководителя);
		ДанныеПечати.Вставить("РасшифровкаПодписиГлавногоБухгалтера", РасшифровкаПодписиГлавногоБухгалтера);
		
		// Области
		МассивОбластейМакета = Новый Массив;
		
		// Печать с логотипом.
		Если ЗначениеЗаполнено(Шапка.ФайлЛоготип) Тогда 
			МассивОбластейМакета.Добавить("ЗаголовокСЛоготипом");			
		Иначе 	
			МассивОбластейМакета.Добавить("Заголовок");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Шапка.Комментарий) Тогда
			Если ЗначениеЗаполнено(Шапка.ФайлЛоготип) Тогда 
				МассивОбластейМакета.Добавить("КомментарийСЛоготипом");			
			Иначе 	
				МассивОбластейМакета.Добавить("Комментарий");
			КонецЕсли;			
		КонецЕсли;
		
		Если ЕстьСкидка Тогда 
			МассивОбластейМакета.Добавить("ШапкаТаблицыСоСкидкой");
			МассивОбластейМакета.Добавить("СтрокаСоСкидкой");
		Иначе 
			МассивОбластейМакета.Добавить("ШапкаТаблицы");
			МассивОбластейМакета.Добавить("Строка");
		КонецЕсли;	
		МассивОбластейМакета.Добавить("Подвал");
		МассивОбластейМакета.Добавить("Итоги");
		МассивОбластейМакета.Добавить("ИтогиНДС");
		МассивОбластейМакета.Добавить("ИтогиНСП");
		Если ЕстьСкидка Тогда 
			МассивОбластейМакета.Добавить("ИтогиСкидка");
		КонецЕсли;	
		МассивОбластейМакета.Добавить("СуммаПрописью");
		МассивОбластейМакета.Добавить("ПодписиСФаксимиле");
	
		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если ИмяОбласти = "ЗаголовокСЛоготипом" Тогда
				Логотип = Новый Соответствие; // Ключ - имя каринки в области, Значение - имя реквизита
				Логотип.Вставить("Логотип", "ФайлЛоготип");
				ЗаполнитьЛоготипФаксимилеВОбластиМакета(ОбластьМакета, ДанныеПечати, Логотип, Ошибки);
			КонецЕсли;	
			
			Если ИмяОбласти <> "Строка" И ИмяОбласти <> "СтрокаСоСкидкой" Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
				
			Иначе 
				Для Каждого СтрокаТаблицы Из ТаблицаТовары Цикл
					ОбластьМакета.Параметры.Заполнить(СтрокаТаблицы);
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
				Для Каждого СтрокаТаблицы Из ТаблицаУслуги Цикл
					ОбластьМакета.Параметры.Заполнить(СтрокаТаблицы);
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
			КонецЕсли;	
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
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
		"СчетНаОплату", НСтр("ru = 'Счет на оплату'"), ПечатьСчетНаОплату(МассивОбъектов, ОбъектыПечати),,
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
	КомандаПечати.Представление = НСтр("ru = 'Счет на оплату'");
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "РеестрСчетНаОплатуПокупателю";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Счет на оплату покупателю""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает заголовок документа для печатной формы.
//
// Параметры:
//  Шапка - любая структура с полями:
//           Номер         - Строка или Число - номер документа;
//           Дата          - Дата - дата документа;
//           Представление - Строка - (необязательный) платформенное представление ссылки на документ.
//                                    Если параметр НазваниеДокумента не задан, то название документа будет вычисляться
//                                    из этого параметра.
//  НазваниеДокумента - Строка - название документа (например, "Счет на оплату").
//
// Возвращаемое значение:
//  Строка - заголовок документа.
//
Функция СформироватьЗаголовокДокумента(Шапка, Знач НазваниеДокумента = "")
	
	ДанныеДокумента = Новый Структура("Номер,Дата,Представление");
	ЗаполнитьЗначенияСвойств(ДанныеДокумента, Шапка);
	
	// Если название документа не передано, получим название по представлению документа.
	Если ПустаяСтрока(НазваниеДокумента) И ЗначениеЗаполнено(ДанныеДокумента.Представление) Тогда
		ПоложениеНомера = СтрНайти(ДанныеДокумента.Представление, ДанныеДокумента.Номер);
		Если ПоложениеНомера > 0 Тогда
			НазваниеДокумента = СокрЛП(Лев(ДанныеДокумента.Представление, ПоложениеНомера - 1));
		КонецЕсли;
	КонецЕсли;

	НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокумента.Номер);
	Возврат СтрШаблон(НСтр("ru = '%1 № %2 от %3'"),
		НазваниеДокумента, НомерНаПечать, Формат(ДанныеДокумента.Дата, "ДЛФ=DD"));
	
КонецФункции

Процедура ЗаполнитьЛоготипФаксимилеВОбластиМакета(ОбластьМакета, ДанныеОбъекта, ПодписиИФаксимиле, Ошибки)
	
	Для каждого ЭлементСоответствия Из ПодписиИФаксимиле Цикл
		
		ПлашкаПодписи = ПолучитьПлашкуПодписиБезопасно(ОбластьМакета, ЭлементСоответствия.Ключ, "", Ошибки);
		Если ПлашкаПодписи = Неопределено Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДанныеОбъекта[ЭлементСоответствия.Значение]) Тогда
			
			ДвоичныеДанные = РаботаСФайлами.ДвоичныеДанныеФайла(ДанныеОбъекта[ЭлементСоответствия.Значение]);
			Если ЗначениеЗаполнено(ДвоичныеДанные) Тогда
				
				ПлашкаПодписи.Картинка = Новый Картинка(ДвоичныеДанные);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьПлашкуПодписиБезопасно(ОбластьМакета, ИмяПлашки, ПредставлениеПодписи, Ошибки)
	
	ПлашкаПодписи = ОбластьМакета.Области.Найти(ИмяПлашки);
	Если ПлашкаПодписи = Неопределено Тогда
		
		ТекстСообщения = НСтр("ru ='ВНИМАНИЕ! Нет места для картинки %1. Возможно используется пользовательский макет.'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ?(ПустаяСтрока(ПредставлениеПодписи), ИмяПлашки, ПредставлениеПодписи));
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, Неопределено, ТекстСообщения, Неопределено);
		
	КонецЕсли;
	
	ПлашкаПодписи.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.НетЛинии);
	
	Возврат ПлашкаПодписи;
	
КонецФункции

#КонецОбласти

#КонецЕсли