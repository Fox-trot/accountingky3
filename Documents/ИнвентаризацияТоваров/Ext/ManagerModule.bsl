﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
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

// Функция формирует табличный документ с печатной формой ФормаИнвентаризационнаяОписьИНВ19
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатнаяФормаИнвентаризационнаяОписьИНВ19(МассивОбъектов, ОбъектыПечати)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ИнвентаризацияТоваров.Ссылка,
		|	ИнвентаризацияТоваров.Номер КАК НомерДокумента,
		|	ИнвентаризацияТоваров.Дата КАК ДатаДокумента,
		|	ИнвентаризацияТоваров.Организация,
		|	ИнвентаризацияТоваров.Организация.КодПоОКПО КАК ОКПО,
		|	ИнвентаризацияТоваров.Склад КАК Подразделение,
		|	ИнвентаризацияТоваров.ДатаНачала КАК ДатаНачалаИнвентаризации,
		|	ИнвентаризацияТоваров.ДатаОкончания КАК ДатаОкончанияИнвентаризации,
		|	ИнвентаризацияТоваров.НаОсновании КАК ДокументОснованиеВид,
		|	ИнвентаризацияТоваров.ДатаОснования КАК ДокументОснованиеДата,
		|	ИнвентаризацияТоваров.НомерОснования КАК ДокументОснованиеНомер,
		|	ИнвентаризацияТоваров.Комиссия.(
		|		ФизЛицо КАК ФизЛицо,
		|		Председатель КАК Председатель
		|	) КАК ИнвентаризационнаяКомиссия,
		|	ИнвентаризацияТоваров.Товары.(
		|		Номенклатура.Наименование КАК ТоварНаименование,
		|		Номенклатура.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмеренияНаименование,
		|		Количество КАК ФактКоличество,
		|		УчетноеКоличество КАК БухКоличество,
		|		Цена,
		|		ВЫРАЗИТЬ(ВЫБОР
		|				КОГДА ИнвентаризацияТоваров.Товары.Отклонение > 0
		|					ТОГДА ИнвентаризацияТоваров.Товары.Отклонение
		|				ИНАЧЕ 0
		|			КОНЕЦ КАК ЧИСЛО) КАК ИзлишекКоличество,
		|		ВЫРАЗИТЬ(ВЫБОР
		|				КОГДА ИнвентаризацияТоваров.Товары.Отклонение < 0
		|					ТОГДА -1*ИнвентаризацияТоваров.Товары.Отклонение
		|				ИНАЧЕ 0
		|			КОНЕЦ КАК ЧИСЛО) КАК НедостачаКоличество,
		|		ВЫРАЗИТЬ(ВЫБОР
		|				КОГДА ИнвентаризацияТоваров.Товары.УчетнаяСумма - ИнвентаризацияТоваров.Товары.Сумма > 0
		|					ТОГДА ИнвентаризацияТоваров.Товары.УчетнаяСумма - ИнвентаризацияТоваров.Товары.Сумма
		|				ИНАЧЕ 0
		|			КОНЕЦ КАК ЧИСЛО) КАК ИзлишекСумма,
		|		ВЫРАЗИТЬ(ВЫБОР
		|				КОГДА ИнвентаризацияТоваров.Товары.УчетнаяСумма - ИнвентаризацияТоваров.Товары.Сумма < 0
		|					ТОГДА -1*(ИнвентаризацияТоваров.Товары.УчетнаяСумма - ИнвентаризацияТоваров.Товары.Сумма)
		|				ИНАЧЕ 0
		|			КОНЕЦ КАК ЧИСЛО) КАК НедостачаСумма
		|	),
		|	ИнвентаризацияТоваров.МБП.(
		|		Номенклатура.Наименование КАК ТоварНаименование,
		|		Номенклатура.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмеренияНаименование,
		|		Количество КАК ФактКоличество,
		|		УчетноеКоличество КАК БухКоличество,
		|		Цена,
		|		ВЫРАЗИТЬ(ВЫБОР
		|				КОГДА ИнвентаризацияТоваров.МБП.Отклонение > 0
		|					ТОГДА ИнвентаризацияТоваров.МБП.Отклонение
		|				ИНАЧЕ 0
		|			КОНЕЦ КАК ЧИСЛО) КАК ИзлишекКоличество,
		|		ВЫРАЗИТЬ(ВЫБОР
		|				КОГДА ИнвентаризацияТоваров.МБП.Отклонение < 0
		|					ТОГДА -1*ИнвентаризацияТоваров.МБП.Отклонение
		|				ИНАЧЕ 0
		|			КОНЕЦ КАК ЧИСЛО) КАК НедостачаКоличество,
		|		ВЫРАЗИТЬ(ВЫБОР
		|				КОГДА ИнвентаризацияТоваров.МБП.УчетнаяСумма - ИнвентаризацияТоваров.МБП.Сумма > 0
		|					ТОГДА ИнвентаризацияТоваров.МБП.УчетнаяСумма - ИнвентаризацияТоваров.МБП.Сумма
		|				ИНАЧЕ 0
		|			КОНЕЦ КАК ЧИСЛО) КАК ИзлишекСумма,
		|		ВЫРАЗИТЬ(ВЫБОР
		|				КОГДА ИнвентаризацияТоваров.МБП.УчетнаяСумма - ИнвентаризацияТоваров.МБП.Сумма < 0
		|					ТОГДА -1*(ИнвентаризацияТоваров.МБП.УчетнаяСумма - ИнвентаризацияТоваров.МБП.Сумма)
		|				ИНАЧЕ 0
		|			КОНЕЦ КАК ЧИСЛО) КАК НедостачаСумма
		|	),
		|	ИнвентаризацияТоваров.ФизЛицо КАК Мол
		|ИЗ
		|	Документ.ИнвентаризацияТоваров КАК ИнвентаризацияТоваров
		|ГДЕ
		|	ИнвентаризацияТоваров.Ссылка В(&СписокДокументов)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДокументОснованиеНомер
		|АВТОУПОРЯДОЧИВАНИЕ";

	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	ВыборкаЗаголовок = Запрос.Выполнить().Выбрать();

	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ИнвентаризацияТоваров_ИнвентаризационнаяОписьИНВ19";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИнвентаризацияТоваров.ПФ_MXL_ИнвентаризационнаяОписьИНВ19");		
	
	НомерСтроки = 0;
	
	Пока ВыборкаЗаголовок.Следующий()  Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли; 
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;

		ДанныеПечати.Вставить("ДокументНомер", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаЗаголовок.НомерДокумента));
		ДанныеПечати.Вставить("ДокументДата", ВыборкаЗаголовок.ДатаДокумента);
		ДанныеПечати.Вставить("НомерСтроки", НомерСтроки);
		
		ВременнаяТаблицаТовары = ВыборкаЗаголовок.Товары.Выгрузить();
		ВременнаяТаблицаМБП = ВыборкаЗаголовок.МБП.Выгрузить();
		
		ИТКоличествоИзлишки = Число(ВременнаяТаблицаТовары.Итог("ИзлишекКоличество")+ВременнаяТаблицаМБП.Итог("ИзлишекКоличество"));
		ИТСуммаИзлишки = ВременнаяТаблицаТовары.Итог("ИзлишекСумма")+ВременнаяТаблицаМБП.Итог("ИзлишекСумма");
		ИТКоличествоНедостача = Число(ВременнаяТаблицаТовары.Итог("НедостачаКоличество")+ВременнаяТаблицаМБП.Итог("НедостачаКоличество"));
		ИТСуммаНедостача = ВременнаяТаблицаТовары.Итог("НедостачаСумма")+ВременнаяТаблицаМБП.Итог("НедостачаСумма");

		ДанныеПечати.Вставить("ИТКоличествоИзлишки",ИТКоличествоИзлишки);
		ДанныеПечати.Вставить("ИТСуммаИзлишки",ИТСуммаИзлишки);
		ДанныеПечати.Вставить("ИТКоличествоНедостача",ИТКоличествоНедостача);
		ДанныеПечати.Вставить("ИТСуммаНедостача",ИТСуммаНедостача);
		
		// Инициализация массива областей макета
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("ШапкаВерх");
		МассивОбластейМакета.Добавить("ШапкаСличВедомость");
		МассивОбластейМакета.Добавить("ШапкаМОЛ");
		МассивОбластейМакета.Добавить("ШапкаТаблицы");
		МассивОбластейМакета.Добавить("Строка");
		МассивОбластейМакета.Добавить("ИтогиСтрок");
		МассивОбластейМакета.Добавить("ПодписьГлБухгалтера");
		МассивОбластейМакета.Добавить("ПодвалНиз");
			
		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если ИмяОбласти = "ШапкаВерх"
				ИЛИ ИмяОбласти = "ШапкаТаблицы" Тогда
				ОбластьМакета.Параметры.Заполнить(ВыборкаЗаголовок);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			ИначеЕсли ИмяОбласти = "ШапкаСличВедомость" Тогда 
				ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			ИначеЕсли ИмяОбласти = "ШапкаМОЛ" Тогда
				ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			ИначеЕсли ИмяОбласти = "Строка" Тогда 
				Для Каждого СтрокаТаблицы Из ВременнаяТаблицаТовары Цикл
					Если СтрокаТаблицы.ИзлишекКоличество	= 0
						И СтрокаТаблицы.ИзлишекСумма   	    = 0 
						И СтрокаТаблицы.НедостачаКоличество = 0 
						И СтрокаТаблицы.НедостачаСумма		= 0 Тогда 
						
						Продолжить;	
					КонецЕсли;
					НомерСтроки = НомерСтроки + 1;
					ОбластьМакета.Параметры.Заполнить(СтрокаТаблицы);
					ОбластьМакета.Параметры.Заполнить(ДанныеПечати);	
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
				Для Каждого СтрокаТаблицы Из ВременнаяТаблицаМБП Цикл
					Если СтрокаТаблицы.ИзлишекКоличество	= 0
						И СтрокаТаблицы.ИзлишекСумма   	    = 0 
						И СтрокаТаблицы.НедостачаКоличество = 0 
						И СтрокаТаблицы.НедостачаСумма		= 0 Тогда  
						
						Продолжить;	
					КонецЕсли;
					НомерСтроки = НомерСтроки + 1;
					ОбластьМакета.Параметры.Заполнить(СтрокаТаблицы);
					ОбластьМакета.Параметры.Заполнить(ДанныеПечати);	
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
			ИначеЕсли ИмяОбласти = "ИтогиСтрок" Тогда
				ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			ИначеЕсли ИмяОбласти = "ПодписьГлБухгалтера"
				ИЛИ ИмяОбласти = "ПодвалНиз" Тогда
				ТабличныйДокумент.Вывести(ОбластьМакета);
			КонецЕсли;	
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаЗаголовок.Ссылка);
	КонецЦикла;
	
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;

	Возврат ТабличныйДокумент;

КонецФункции

// Функция формирует табличный документ с печатной формой ИнвентаризацияТоваров_ИНВ3
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьИнвентаризацияТоваров_ИНВ3(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ИнвентаризацияТоваров_ИнвентаризацияТоваров_ИНВ3";
	
	// Варианты заголовков разделов с подписями печатной формы	
	ЗаголовокРазделаКомиссии = Новый Структура();
	ЗаголовокРазделаКомиссии.Вставить("ПредседательКомиссии", НСтр("ru = 'Председатель комиссии'"));
	ЗаголовокРазделаКомиссии.Вставить("ЧленыКомиссии",        НСтр("ru = 'Члены комиссии'"));
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ИнвентаризацияТоваров.Ссылка,
	|	ИнвентаризацияТоваров.Номер КАК НомерДокумента,
	|	ИнвентаризацияТоваров.Дата КАК ДатаДокумента,
	|	ИнвентаризацияТоваров.Организация,
	|	ИнвентаризацияТоваров.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
	|	ИнвентаризацияТоваров.Организация.КодПоОКПО КАК КодПоОКПО,
	|	ИнвентаризацияТоваров.Склад,
	|	ИнвентаризацияТоваров.ДатаНачала КАК ДатаНачалаИнвентаризации,
	|	ИнвентаризацияТоваров.ДатаОкончания КАК ДатаОкончанияИнвентаризации,
	|	ИнвентаризацияТоваров.НаОсновании КАК ДокументОснованиеВид,
	|	ИнвентаризацияТоваров.ДатаОснования КАК ДокументОснованиеДата,
	|	ИнвентаризацияТоваров.НомерОснования КАК ДокументОснованиеНомер,
	|	ИнвентаризацияТоваров.Комиссия.(
	|		ФизЛицо КАК ФизЛицо,
	|		Председатель КАК Председатель
	|	) КАК ИнвентаризационнаяКомиссия,
	|	ИнвентаризацияТоваров.Товары.(
	|		Номенклатура.Наименование КАК ТоварНаименование,
	|		Номенклатура.Код КАК ТоварКод,
	|		Номенклатура.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмеренияНаименование,
	|		Количество КАК ФактКоличество,
	|		УчетноеКоличество КАК БухКоличество,
	|		Сумма КАК ФактСумма,
	|		УчетнаяСумма КАК БухСумма,
	|		СчетУчета КАК СубСчет,
	|		Цена
	|	),
	|	ИнвентаризацияТоваров.МБП.(
	|		Номенклатура.Наименование КАК ТоварНаименование,
	|		Номенклатура.Код КАК ТоварКод,
	|		Номенклатура.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмеренияНаименование,
	|		Количество КАК ФактКоличество,
	|		УчетноеКоличество КАК БухКоличество,
	|		Цена,
	|		Сумма КАК ФактСумма,
	|		УчетнаяСумма КАК БухСумма,
	|		""1750"" КАК СубСчет
	|	)
	|ИЗ
	|	Документ.ИнвентаризацияТоваров КАК ИнвентаризацияТоваров
	|ГДЕ
	|	ИнвентаризацияТоваров.Ссылка В(&СписокДокументов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокументОснованиеНомер
	|АВТОУПОРЯДОЧИВАНИЕ";

				
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	РезультатЗапроса 	= Запрос.Выполнить();
	ВыборкаДок 			= РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДок.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ВременнаяТаблицаТовары 			= ВыборкаДок.Товары.Выгрузить();
		ВременнаяТаблицаМБП 				= ВыборкаДок.МБП.Выгрузить();
		ОбщееКоличествоСтрок 	= ВременнаяТаблицаТовары.Количество() + ВременнаяТаблицаМБП.Количество();
		ОбщееКоличествоФакт 	= ВременнаяТаблицаТовары.Итог("ФактКоличество") + ВременнаяТаблицаМБП.Итог("ФактКоличество");
		ОбщееСуммаФакт 			= ВременнаяТаблицаТовары.Итог("ФактСумма") + ВременнаяТаблицаМБП.Итог("ФактСумма");
		
		ВидЦенностей = "";
		Если ВременнаяТаблицаТовары.Количество() Тогда
			ВидЦенностей = НСтр("ru = 'Товары (материалы)'");	
		КонецЕсли;
		Если ВременнаяТаблицаМБП.Количество() Тогда
			ВидЦенностей = ВидЦенностей + ?(ЗначениеЗаполнено(ВидЦенностей), ", ", "") + НСтр("ru = 'МБП'");	
		КонецЕсли;

		ДанныеПечати = Новый Структура;
		
		ДанныеПечати.Вставить("ОрганизацияНаименованиеПолное", ВыборкаДок.ОрганизацияНаименованиеПолное);
		ДанныеПечати.Вставить("ОрганизацияПоОКПО", 			ВыборкаДок.КодПоОКПО);
		ДанныеПечати.Вставить("Подразделение", 				ВыборкаДок.Склад);
		ДанныеПечати.Вставить("ДатаДокумента", 				ВыборкаДок.ДатаДокумента);
		ДанныеПечати.Вставить("НомерДокумента", 			ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаДок.НомерДокумента));		
		ДанныеПечати.Вставить("ДокументОснованиеДата", 		Формат(ВыборкаДок.ДокументОснованиеДата,"ДЛФ=DD"));
		ДанныеПечати.Вставить("ДатаНачалаИнвентаризации", 	Формат(ВыборкаДок.ДатаНачалаИнвентаризации,"ДЛФ=DD"));
		ДанныеПечати.Вставить("ДатаОкончанияИнвентаризации",Формат(ВыборкаДок.ДатаОкончанияИнвентаризации,"ДЛФ=DD"));
		ДанныеПечати.Вставить("ДатаДок",					Формат(ВыборкаДок.ДатаДокумента,"ДЛФ=DD"));
		ДанныеПечати.Вставить("ВидЦенностей", 				ВидЦенностей);
		
		ДанныеПечати.Вставить("КоличествоПорядковыхНомеровНаСтраницеПрописью", Строка(ОбщееКоличествоСтрок) + "(" + БухгалтерскийУчетСервер.КоличествоПрописью(ОбщееКоличествоСтрок) + ")");
		ДанныеПечати.Вставить("ОбщееКоличествоЕдиницФактическиНаСтраницеПрописью", Строка(ОбщееКоличествоФакт) + "(" + БухгалтерскийУчетСервер.КоличествоПрописью(ОбщееКоличествоФакт) + ")");		
		ДанныеПечати.Вставить("СуммаФактическиНаСтраницеПрописью", Строка(ОбщееСуммаФакт) + "(" + БухгалтерскийУчетСервер.СформироватьСуммуПрописью(ОбщееСуммаФакт) + ")");
		ДанныеПечати.Вставить("НачальныйНомерПоПорядку", 1);	
		ДанныеПечати.Вставить("НомерКонца", ОбщееКоличествоСтрок);	
			
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИнвентаризацияТоваров.ПФ_MXL_ИнвентаризацияТоваров_ИНВ3");
		
		МассивОбластейМакета = Новый Массив;		
		МассивОбластейМакета.Добавить("Шапка");
		МассивОбластейМакета.Добавить("ЗаголовокТаблицы");
		МассивОбластейМакета.Добавить("Строка");
		МассивОбластейМакета.Добавить("Итоги");
		МассивОбластейМакета.Добавить("Комиссия");
		МассивОбластейМакета.Добавить("ПодвалОписи");
		
		ВыборкаСтрокТовары 		= ВыборкаДок.Товары.Выбрать();
		ВыборкаСтрокМБП 		= ВыборкаДок.МБП.Выбрать();
		НомерСтроки = 0;
		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);			
			Если ИмяОбласти <> "Строка" И ИмяОбласти <> "Комиссия" Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ВыборкаДок);
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);								
			ИначеЕсли ИмяОбласти = "Строка" Тогда 
				Пока ВыборкаСтрокТовары.Следующий() Цикл
					ОбластьМакета = Макет.ПолучитьОбласть("Строка");
					ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
					НомерСтроки = НомерСтроки + 1;
					ОбластьМакета.Параметры.Номер = НомерСтроки;
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
				Пока ВыборкаСтрокМБП.Следующий() Цикл
					ОбластьМакета = Макет.ПолучитьОбласть("Строка");
					ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокМБП);
					НомерСтроки = НомерСтроки + 1;
					ОбластьМакета.Параметры.Номер = НомерСтроки;
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
			ИначеЕсли ИмяОбласти = "Комиссия" Тогда
				ВыборкаСтрокКомиссия	= ВыборкаДок.ИнвентаризационнаяКомиссия.Выбрать();
				Пока ВыборкаСтрокКомиссия.Следующий() Цикл
					Если ВыборкаСтрокКомиссия.Председатель Тогда
						ДанныеФизЛица = БухгалтерскийУчетСервер.ДанныеФизЛица(ВыборкаДок.Организация,ВыборкаСтрокКомиссия.ФизЛицо, ВыборкаДок.ДатаДокумента);
						ОбластьМакета.Параметры.ЗаголовокКомиссии = ЗаголовокРазделаКомиссии.ПредседательКомиссии;
						ОбластьМакета.Параметры.ДолжностьКомиссии = ДанныеФизЛица.Должность;
						ОбластьМакета.Параметры.ФИОКомиссии       = ДанныеФизЛица.Представление;
						ТабличныйДокумент.Вывести(ОбластьМакета);
						Прервать;
					КонецЕсли;
				КонецЦикла;
				ПервыйЧленКомиссии = Истина;
				ВыборкаСтрокКомиссия.Сбросить();
				Пока ВыборкаСтрокКомиссия.Следующий() Цикл
					Если НЕ ВыборкаСтрокКомиссия.Председатель Тогда
						ДанныеФизЛица = БухгалтерскийУчетСервер.ДанныеФизЛица(ВыборкаДок.Организация,ВыборкаСтрокКомиссия.ФизЛицо, ВыборкаДок.ДатаДокумента);
						ОбластьМакета.Параметры.ЗаголовокКомиссии = ?(ПервыйЧленКомиссии, ЗаголовокРазделаКомиссии.ЧленыКомиссии, "");
						ОбластьМакета.Параметры.ДолжностьКомиссии = ДанныеФизЛица.Должность;
						ОбластьМакета.Параметры.ФИОКомиссии       = ДанныеФизЛица.Представление;
						ТабличныйДокумент.Вывести(ОбластьМакета);
						ПервыйЧленКомиссии = Ложь;
					КонецЕсли;
				КонецЦикла; 
				
			КонецЕсли;
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДок.Ссылка);		
	КонецЦикла;
	
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.ПолеСлева = 0;
	
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
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИнвентаризацияТоваров_ИНВ3") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"ИнвентаризацияТоваров_ИНВ3", 
		НСтр("ru = 'ИНВ-3 (Инвентаризационная опись товаров)'"), 
		ПечатьИнвентаризацияТоваров_ИНВ3(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.Доверенность.ПФ_MXL_ИнвентаризацияТоваров_ИНВ3");
	КонецЕсли;
	
		// печать Инвентаризационная опись ИНВ-19
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИнвентаризационнаяОписьИНВ19");
	Если НужноПечататьМакет Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		"ИнвентаризационнаяОписьИНВ19",
		НСтр("ru = 'Инвентаризационная опись ИНВ-19'"),
		ПечатнаяФормаИнвентаризационнаяОписьИНВ19(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.ИнвентаризацияТоваров.ПФ_MXL_ИнвентаризационнаяОписьИНВ19");
	КонецЕсли; 

КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ИнвентаризацияТоваров_ИНВ3";
	КомандаПечати.Представление = НСтр("ru = 'ИНВ-3 (Инвентаризационная опись товаров)'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
		// Инвентаризационная Инвентаризационная опись ИНВ-18 
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ИнвентаризационнаяОписьИНВ19";
	КомандаПечати.Представление = НСтр("ru = 'Инвентаризационная опись ИНВ-19'");
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли