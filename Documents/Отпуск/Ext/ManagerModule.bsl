﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаНачисления(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(ВременнаяТаблицаШапка.Дата, МЕСЯЦ) КАК ПериодРегистрации,
		|	ТаблицаДокумента.ДатаНачала КАК ПериодДействияНачало,
		|	КОНЕЦПЕРИОДА(ТаблицаДокумента.ДатаОкончания, ДЕНЬ) КАК ПериодДействияКонец,
		|	ТаблицаДокумента.ВидРасчета КАК ВидРасчета,
		|	ТаблицаДокумента.СпособОтражения КАК СпособОтражения,
		|	ВременнаяТаблицаШапка.ФизЛицо КАК ФизЛицо,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Подразделение КАК Подразделение,
		|	ВременнаяТаблицаШапка.Должность КАК Должность,
		|	ТаблицаДокумента.Размер КАК Размер,
		|	ТаблицаДокумента.Результат КАК Результат,
		|	ТаблицаДокумента.ОтработаноДней КАК ОтработаноДней,
		|	ВременнаяТаблицаШапка.ГрафикРаботы КАК ГрафикРаботы
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаНачисления КАК ТаблицаДокумента
		|		ПО (ИСТИНА)";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаНачисления", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаНачисления()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Дата,
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.ФизЛицо,
		|	ТаблицаДокумента.Подразделение,
		|	ТаблицаДокумента.Должность,
		|	ТаблицаДокумента.ГрафикРаботы,
		|	ТаблицаДокумента.Дней,
		|	ТаблицаДокумента.ДатаНачала,
		|	ТаблицаДокумента.ДатаОкончания,
		|	ТаблицаДокумента.МетодРасчета.РасчетПоРабочимДням КАК РасчетПоРабочимДням,
		|	ТаблицаДокумента.МетодРасчета
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.Отпуск КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ДатаНачала,
		|	ТаблицаДокумента.ВидРасчета,
		|	ТаблицаДокумента.ДатаОкончания,
		|	ТаблицаДокумента.ОтработаноДней,
		|	ТаблицаДокумента.Размер,
		|	ТаблицаДокумента.Результат,
		|	ТаблицаДокумента.СпособОтражения
		|ПОМЕСТИТЬ ВременнаяТаблицаНачисления
		|ИЗ
		|	Документ.Отпуск.Начисления КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТаблицаНачисления(ДокументСсылка, СтруктураДополнительныеСвойства);
КонецПроцедуры // ИнициализироватьДанныеДокумента()

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

// Формирует запрос по документу.
//
Функция СформироватьЗапросДляПечати(МассивОбъектов)
	
	Запрос = Новый Запрос;	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Отпуск.Ссылка КАК Ссылка,
		|	Отпуск.Дата КАК ДатаДокумента,
		|	Отпуск.Номер КАК НомерДокумента,
		|	Отпуск.Организация КАК Организация,
		|	Отпуск.Организация.НаименованиеПолное КАК ОрганизацияПредставление,
		|	Отпуск.Организация.КодПоОКПО КАК КодПоОКПО,
		|	Отпуск.ФизЛицо КАК ФизЛицо,
		|	Отпуск.ФизЛицо.Наименование КАК ФизЛицоПредставление,
		|	Отпуск.ФизЛицо.Код КАК ТабельныйНомер,
		|	Отпуск.Должность.Наименование КАК ДолжностьПредставление,
		|	Отпуск.Подразделение.Наименование КАК ПодразделениеПредставление,
		|	Отпуск.МетодРасчета.Наименование КАК МетодРасчетаПредставление,
		|	Отпуск.Дней КАК Дней,
		|	Отпуск.ДатаНачала КАК ДатаНачала,
		|	Отпуск.ДатаОкончания КАК ДатаОкончания,
		|	Отпуск.МетодРасчета.ВидОтпуска КАК ВидОтпуска,
		|	Отпуск.МетодРасчета.КоэффициентРасчета КАК КоэффициентРасчета,
		|	Отпуск.МетодРасчета.ВидРасчета КАК ВидРасчета,
		|	Отпуск.МетодРасчета.РасчетПоРабочимДням КАК РасчетПоРабочимДням,
		|	Отпуск.СреднийЗаработок.(
		|		ПериодРегистрации КАК ПериодРегистрации,
		|		КоэффициентРасчета КАК КоэффициентРасчета,
		|		Результат КАК СуммаСреднийЗаработок
		|	) КАК СреднийЗаработок,
		|	Отпуск.Начисления.(
		|		ПериодРегистрации КАК ПериодРегистрации,
		|		ДатаНачала КАК ДатаНачала,
		|		ДатаОкончания КАК ДатаОкончания,
		|		ОтработаноДней КАК ОтработаноДней,
		|		Результат КАК СуммаНачислено,
		|		СпособОтражения КАК СпособОтражения
		|	) КАК Начисления
		|ИЗ
		|	Документ.Отпуск КАК Отпуск
		|ГДЕ
		|	Отпуск.Ссылка В(&МассивОбъектов)";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Возврат Запрос.Выполнить();
	
КонецФункции

// Сформировать печатные формы объектов
//
Функция ПечатьПриказаНаОтпуск(МассивОбъектов, ОбъектыПечати)
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "Отпуск_ПриказНаОтпуск";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Отпуск.ПФ_MXL_ПриказНаОтпуск");		
	
	Шапка = СформироватьЗапросДляПечати(МассивОбъектов).Выбрать();
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("ОрганизацияПредставление", Шапка.ОрганизацияПредставление);
		НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.НомерДокумента);
		ДанныеПечати.Вставить("НомерДокумента", НомерНаПечать);
		ДанныеПечати.Вставить("ДатаДокумента", Шапка.ДатаДокумента);
		
		ДанныеПечати.Вставить("ФизЛицоПредставление", Шапка.ФизЛицоПредставление);
		ДанныеПечати.Вставить("ТабельныйНомер", Шапка.ТабельныйНомер);
		ДанныеПечати.Вставить("ДолжностьПредставление", Шапка.ДолжностьПредставление);
		ДанныеПечати.Вставить("ПодразделениеПредставление", Шапка.ПодразделениеПредставление);
		ДанныеПечати.Вставить("МетодРасчетаПредставление", Шапка.МетодРасчетаПредставление);
		
		ДанныеПечати.Вставить("Дней", Шапка.Дней);
		
		ДанныеПечати.Вставить("ДатаНачала", Формат(Шапка.ДатаНачала, "ДЛФ=D"));
		ДанныеПечати.Вставить("ДатаОкончания", Формат(Шапка.ДатаОкончания, "ДЛФ=D"));
		
		// Подписи.
		ФамилияИОРуководителя = "";
		ОтветственныеЛица = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизацийРуководители(Шапка.Организация, Шапка.ДатаДокумента);
		БухгалтерскийУчетСервер.ФамилияИнициалыПоНаименованию(ФамилияИОРуководителя, ОтветственныеЛица.Руководитель);
		ДанныеПечати.Вставить("ФамилияИОРуководителя", ФамилияИОРуководителя);
		ДанныеПечати.Вставить("ДолжностьРуководителя", ОтветственныеЛица.РуководительДолжность);
		
		// Области
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Заголовок");
		
		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

Функция ПечатьЗапискиРасчетОПредоставленииОтпуска(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "Отпуск_ЗапискаРасчетОПредоставленииОтпуска";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Отпуск.ПФ_MXL_ЗапискаРасчетОПредоставленииОтпуска");		
	
	ВалютаРегламентированногоУчета 	= ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();

	Шапка = СформироватьЗапросДляПечати(МассивОбъектов).Выбрать();
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("ОрганизацияПредставление", Шапка.ОрганизацияПредставление);
		НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.НомерДокумента);
		ДанныеПечати.Вставить("НомерДокумента", НомерНаПечать);
		ДанныеПечати.Вставить("ДатаДокумента", Шапка.ДатаДокумента);
		
		ДанныеПечати.Вставить("ФизЛицоПредставление", Шапка.ФизЛицоПредставление);
		ДанныеПечати.Вставить("ТабельныйНомер", Шапка.ТабельныйНомер);
		ДанныеПечати.Вставить("ДолжностьПредставление", Шапка.ДолжностьПредставление);
		ДанныеПечати.Вставить("ПодразделениеПредставление", Шапка.ПодразделениеПредставление);
		
		ДанныеПечати.Вставить("Дней", Шапка.Дней);
		
		ДанныеПечати.Вставить("ДатаНачалаРабочегоГода", Формат(Шапка.ДатаНачала, "ДФ=yyyy"));
		ДанныеПечати.Вставить("ДатаОкончанияРабочегоГода", Формат(Шапка.ДатаОкончания, "ДФ=yyyy"));
		
		ДанныеПечати.Вставить("ДатаНачала", Формат(Шапка.ДатаНачала, "ДЛФ=D"));
		ДанныеПечати.Вставить("ДатаОкончания", Формат(Шапка.ДатаОкончания, "ДЛФ=D"));
		
		// Таблицы.
		ТаблицаСреднийЗаработок = Шапка.СреднийЗаработок.Выгрузить();
		ТаблицаНачисления = Шапка.Начисления.Выгрузить();
		
		// Средний заработок.
		ДанныеПечати.Вставить("ГодПериодРегистрации", Год(Шапка.ДатаДокумента));
		ДанныеПечати.Вставить("МесяцПериодРегистрации", Месяц(Шапка.ДатаДокумента));

		ИтогоНормаДнейСреднийЗаработок = ТаблицаСреднийЗаработок.Итог("НормаДней");
		ИтогоСуммаСреднийЗаработок = ТаблицаСреднийЗаработок.Итог("СуммаСреднийЗаработок");
		СреднеДневнойЗаработок = ?(ИтогоНормаДнейСреднийЗаработок = 0, 0, ИтогоСуммаСреднийЗаработок / ИтогоНормаДнейСреднийЗаработок);
		
		ДанныеПечати.Вставить("ИтогоНормаДнейСреднийЗаработок", ИтогоНормаДнейСреднийЗаработок);
		ДанныеПечати.Вставить("ИтогоСуммаСреднийЗаработок", ИтогоСуммаСреднийЗаработок);
		ДанныеПечати.Вставить("СреднеДневнойЗаработок", СреднеДневнойЗаработок);
		
		// Начисления.
		ИтогоСуммаНачислено = ТаблицаНачисления.Итог("СуммаНачислено");
		ДанныеПечати.Вставить("ИтогоСуммаНачислено", ИтогоСуммаНачислено);
		ДанныеПечати.Вставить("ИтогоСуммаНачисленоПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(ИтогоСуммаНачислено, ВалютаРегламентированногоУчета));

		// Подписи.
		ФамилияИОГлавногоБухгалтера = "";
		ОтветственныеЛица = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизацийРуководители(Шапка.Организация, Шапка.ДатаДокумента);
		БухгалтерскийУчетСервер.ФамилияИнициалыПоНаименованию(ФамилияИОГлавногоБухгалтера, ОтветственныеЛица.ГлавныйБухгалтер);
		ДанныеПечати.Вставить("ФамилияИОГлавногоБухгалтера", ФамилияИОГлавногоБухгалтера);
		
		// Области
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Заголовок");
		// Средний заработок.
		МассивОбластейМакета.Добавить("ШапкаСреднийЗаработок");
		МассивОбластейМакета.Добавить("СтрокаСреднийЗаработок");
		МассивОбластейМакета.Добавить("ПодвалСреднийЗаработок");
		// Начисления.
		МассивОбластейМакета.Добавить("ШапкаНачисления");
		МассивОбластейМакета.Добавить("СтрокаНачисления");
		
		МассивОбластейМакета.Добавить("Подвал");
		
		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если ИмяОбласти <> "СтрокаСреднийЗаработок"
				И ИмяОбласти <> "СтрокаНачисления" Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			ИначеЕсли ИмяОбласти = "СтрокаСреднийЗаработок" Тогда 
				Для Каждого СтрокаТаблицы Из ТаблицаСреднийЗаработок Цикл
					ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
					ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтрокаТаблицы);
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
			ИначеЕсли ИмяОбласти = "СтрокаНачисления" Тогда 
				Для Каждого СтрокаТаблицы Из ТаблицаНачисления Цикл
					ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтрокаТаблицы);
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
			КонецЕсли;	
		КонецЦикла;

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;

КонецФункции //ПечатьЗапискиРасчетОПредоставленииОтпуска()

Функция ПечатьСправкаПоРасчетуОтпускных(МассивОбъектов, ОбъектыПечати)
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "Отпуск_СправкаПоРасчетуОтпускных";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Отпуск.ПФ_MXL_СправкаПоРасчетуОтпускных");		
	
	Шапка = СформироватьЗапросДляПечати(МассивОбъектов).Выбрать();
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ВсегоНачислено = 0;
		РазмерСреднийЗаработок = 0;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("ДатаНачала", Формат(Шапка.ДатаНачала, "ДЛФ=D"));
		ДанныеПечати.Вставить("ДатаОкончания", Формат(Шапка.ДатаОкончания, "ДЛФ=D"));
		
		ДанныеПечати.Вставить("ФизЛицо", Шапка.ФизЛицоПредставление);
		ДанныеПечати.Вставить("ТабельныйНомер", Шапка.ТабельныйНомер);
		ДанныеПечати.Вставить("Должность", Шапка.ДолжностьПредставление);
		ДанныеПечати.Вставить("Подразделение", Шапка.ПодразделениеПредставление);
		СтатусСотрудника = ПроведениеРасчетовПоЗарплатеСервер.СтатусСотрудникаКакНалогоплательщика(Шапка.ДатаДокумента, Шапка.Организация, Шапка.ФизЛицо);
		ДанныеПечати.Вставить("Статус", СтатусСотрудника.Статус);
		
		ТипРасчета = ?(Шапка.РасчетПоРабочимДням, НСтр("ru = ' (рабочие дни)'"), НСтр("ru = ' (календарные дни)'"));
		ДанныеПечати.Вставить("ДниОтпуска", "" + Шапка.Дней + ТипРасчета);
		ДанныеПечати.Вставить("ВидОтпуска", Шапка.ВидОтпуска);
		ДанныеПечати.Вставить("Коэффициент", Шапка.КоэффициентРасчета);
		
		СреднийЗаработок = Шапка.СреднийЗаработок.Выгрузить();
		Начисления = Шапка.Начисления.Выгрузить();
		
		ДанныеПечатиСреднийЗаработок = Новый Структура;
		ДанныеПечатиОтпускные = Новый Структура;
		ДанныеПечатиПодвал = Новый Структура;
			
		// Области
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Заголовок");
		МассивОбластейМакета.Добавить("ШапкаСреднийЗаработок");
		МассивОбластейМакета.Добавить("СтрокаСреднийЗаработок");
		МассивОбластейМакета.Добавить("ШапкаОтпускные");
		МассивОбластейМакета.Добавить("СтрокаОтпускные");
		МассивОбластейМакета.Добавить("Подвал");
		
		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			
			Если ИмяОбласти = "СтрокаСреднийЗаработок" Тогда
				Для каждого СтрокаТаблицы Из СреднийЗаработок Цикл
					ДанныеПечатиСреднийЗаработок.Вставить("ПериодРегистрации", Формат(СтрокаТаблицы.ПериодРегистрации, "ДЛФ=D"));
					ДанныеПечатиСреднийЗаработок.Вставить("КоэффициентРасчета", СтрокаТаблицы.КоэффициентРасчета);
					ДанныеПечатиСреднийЗаработок.Вставить("СуммаСреднийЗаработок", СтрокаТаблицы.СуммаСреднийЗаработок);
					
					ОбластьМакета.Параметры.Заполнить(ДанныеПечатиСреднийЗаработок);
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
				// База начислений 
				РезультатСреднийЗаработок = СреднийЗаработок.Итог("СуммаСреднийЗаработок");  
				КоличествоМесяцевСреднийЗаработок = СреднийЗаработок.Количество(); 	
				
				// Расчет размера 
				РазмерСреднийЗаработок = РезультатСреднийЗаработок  
						/ ?(КоличествоМесяцевСреднийЗаработок = 0, 1, КоличествоМесяцевСреднийЗаработок)  
						/ ?(Шапка.КоэффициентРасчета = 0, 1, Шапка.КоэффициентРасчета);
				ОбластьИтогоСрденийЗаработок = Макет.ПолучитьОбласть("ИтогоСреднийЗаработок");
				ОбластьИтогоСрденийЗаработок.Параметры.ВсегоСреднийЗаработок = РазмерСреднийЗаработок;
				ОбластьИтогоСрденийЗаработок.Параметры.ИтогоСумма = РезультатСреднийЗаработок;
				ТабличныйДокумент.Вывести(ОбластьИтогоСрденийЗаработок);
			ИначеЕсли ИмяОбласти = "СтрокаОтпускные" Тогда                  
				Для каждого СтрокаТаблицы Из Начисления Цикл
					ДанныеПечатиОтпускные.Вставить("ДатаНачала", 			Формат(СтрокаТаблицы.ДатаНачала, "ДЛФ=D"));
					ДанныеПечатиОтпускные.Вставить("ДатаОкончания", 		Формат(СтрокаТаблицы.ДатаОкончания, "ДЛФ=D"));
					ДанныеПечатиОтпускные.Вставить("ОтработаноДней", 		СтрокаТаблицы.ОтработаноДней);
					ДанныеПечатиОтпускные.Вставить("УчетПоЗП", 				СтрокаТаблицы.СпособОтражения);
					ДанныеПечатиОтпускные.Вставить("СуммаНачислено", 		СтрокаТаблицы.СуммаНачислено);
					
					ОбластьМакета.Параметры.Заполнить(ДанныеПечатиОтпускные);
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
				ВсегоНачислено = Начисления.Итог("СуммаНачислено");
			ИначеЕсли ИмяОбласти = "Подвал" Тогда
				ПенсионныйФонд = 0;
				ПодоходныйНалог = 0;
				 
				Запрос = Новый Запрос;
				Запрос.Текст = "ВЫБРАТЬ
				               |	СтатусыСотрудниковСрезПоследних.ФизЛицо КАК ФизЛицо,
				               |	СтатусыСотрудниковСрезПоследних.Статус КАК Статус,
				               |	ЕСТЬNULL(СтавкиНалоговЗаработнойПлатыСрезПоследних.СтавкаПФР, 0) КАК СтавкаПФР,
				               |	ЕСТЬNULL(СтавкиНалоговЗаработнойПлатыСрезПоследних.СтавкаГНПФР, 0) КАК СтавкаГНПФР,
				               |	ЕСТЬNULL(СтавкиНалоговЗаработнойПлатыСрезПоследних.СтавкаПН, 0) КАК СтавкаПН,
				               |	ЕСТЬNULL(СтавкиНалоговЗаработнойПлатыСрезПоследних.Вычеты, 0) КАК Вычеты
				               |ИЗ
				               |	РегистрСведений.СтатусыСотрудников.СрезПоследних(
				               |			&КонецПериода,
				               |			Организация = &Организация
				               |				И ФизЛицо = &ФизЛицо) КАК СтатусыСотрудниковСрезПоследних
				               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиНалоговЗаработнойПлаты.СрезПоследних(&КонецПериода, ) КАК СтавкиНалоговЗаработнойПлатыСрезПоследних
				               |		ПО СтатусыСотрудниковСрезПоследних.Статус = СтавкиНалоговЗаработнойПлатыСрезПоследних.Статус";
				Запрос.УстановитьПараметр("КонецПериода",  Шапка.ДатаДокумента);
				Запрос.УстановитьПараметр("Организация",  Шапка.Организация);
				Запрос.УстановитьПараметр("ФизЛицо",  Шапка.ФизЛицо);
				Выборка = Запрос.Выполнить().Выбрать();
				Если Выборка.Следующий() Тогда
					Если Шапка.ВидРасчета.ОблагаетсяСФ Тогда
						ПенсионныйФонд = ВсегоНачислено * (Выборка.СтавкаПФР / 100 + Выборка.СтавкаГНПФР / 100);
					КонецЕсли;
					Если Шапка.ВидРасчета.ОблагаетсяПН Тогда
						ПодоходныйНалог = (ВсегоНачислено - ПенсионныйФонд - Выборка.Вычеты * 100) * Выборка.СтавкаПН / 100;
					КонецЕсли;	
				КонецЕсли;	
				ДанныеПечатиПодвал.Вставить("ВсегоНачислено", 	ВсегоНачислено);
				ДанныеПечатиПодвал.Вставить("ПенсионныйФонд", 	ПенсионныйФонд);
				ДанныеПечатиПодвал.Вставить("ПодоходныйНалог", 	ПодоходныйНалог);
				ДанныеПечатиПодвал.Вставить("КВыдаче", 			ВсегоНачислено - ПенсионныйФонд - ПодоходныйНалог);
				
				ОбластьМакета.Параметры.Заполнить(ДанныеПечатиПодвал);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			ИначеЕсли ИмяОбласти <> "СтрокаСреднийЗаработок" И ИмяОбласти <> "СтрокаОтпускные" Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			КонецЕсли;	
		КонецЦикла;

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриказНаОтпуск") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"ПриказНаОтпуск",
		НСтр("ru = 'Приказ на отпуск'"), 
		ПечатьПриказаНаОтпуск(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗапискаРасчетОПредоставленииОтпуска") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"ЗапискаРасчетОПредоставленииОтпуска", 
		НСтр("ru = 'Записка расчет о предоставлении отпуска'"), 
		ПечатьЗапискиРасчетОПредоставленииОтпуска(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СправкаПоРасчетуОтпускных") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"СправкаПоРасчетуОтпускных", 
		НСтр("ru = 'Справка по расчету отпускных'"), 
		ПечатьСправкаПоРасчетуОтпускных(МассивОбъектов, ОбъектыПечати),
		,
		"Документ.Отпуск.ПФ_MXL_СправкаПоРасчетуОтпускных");
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПриказНаОтпуск";
	КомандаПечати.Представление = НСтр("ru = 'Приказ на отпуск'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ЗапискаРасчетОПредоставленииОтпуска";
	КомандаПечати.Представление = НСтр("ru = 'Записка расчет о предоставлении отпуска'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 2;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СправкаПоРасчетуОтпускных";
	КомандаПечати.Представление = НСтр("ru = 'Справка по расчету отпускных'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 3;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "РеестрОтпуск";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Отпуск""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
