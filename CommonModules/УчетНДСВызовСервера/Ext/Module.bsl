﻿
#Область ПрограммныйИнтерфейс

// Функция - Получить ставку НДС
//
// Параметры:
//  Период		 - дата	- дата на которую нужно получить значения ставки
//  СтавкаНДС	 - СправочникСсылка.СтавкиНДС - ссылка на справочник ставки НДС
// Возвращаемое значение:
//   - число - размер ставки
Функция ПолучитьСтавкуНДС(Период, СтавкаНДС) Экспорт
	Возврат УчетНДСПовтИсп.ПолучитьСтавкуНДС(НачалоМесяца(Период), СтавкаНДС);
КонецФункции // ПолучитьСтавкуНДС()

// Функция - Получить ставку НСП
//
// Параметры:
//  Период		 - дата	- дата на которую нужно получить значения ставки
//  Организация	 - СправочникСсылка.Организации - ссылка на справочник Организация
//  СтавкаНСП	 - СправочникСсылка.СтавкаНСП - ссылка на справочник ставки НСП
// Возвращаемое значение:
//   - число - размер ставки
Функция ПолучитьСтавкуНСП(Период, Организация, СтавкаНСП) Экспорт
	Возврат УчетНДСПовтИсп.ПолучитьСтавкуНСП(НачалоМесяца(Период), Организация, СтавкаНСП);
КонецФункции // ПолучитьСтавкуНСП()  

// Функция - Получить значения ставок НДС и НСП
//
// Параметры:
//  Период		- Дата - дата на которую нужно получить значения ставки
//  Контрагент	- СправочникСсылка.Контрагенты	- ссылка на справочник Контрагент
//  Договор	 	- СправочникСсылка.ДоговорыКонтрагентов	- ссылка на справочник Договоры контрагентов
// 
// Возвращаемое значение:
//   - Структура 
//		* ЗначениеСтавкиНДС - число
//		* ЗначениеСтавкиНСП - число
//
Функция ПолучитьЗначенияСтавокНДСиНСП(Период, Договор) Экспорт
	
	СтруктураДанные = Новый Структура("ЗначениеСтавкиНДС, ЗначениеСтавкиНСП, ЗначениеСтавкиНСПДляОС", 0, 0, 0);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗначенияСтавокНалогов.ЗначениеСтавкиНДС КАК ЗначениеСтавкиНДС,
		|	ЗначенияСтавокНалогов.ЗначениеСтавкиНСП КАК ЗначениеСтавкиНСП,
		|	ЗначенияСтавокНалогов.ЗначениеСтавкиНСПДляОС КАК ЗначениеСтавкиНСПДляОС
		|ИЗ
		|	РегистрСведений.ЗначенияСтавокНалогов КАК ЗначенияСтавокНалогов
		|ГДЕ
		|	ЗначенияСтавокНалогов.ДоговорКонтрагента = &Договор";
	Запрос.УстановитьПараметр("Договор", Договор);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда 
		ЗаполнитьЗначенияСвойств(СтруктураДанные, ВыборкаДетальныеЗаписи);		
	КонецЕсли;             

	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьЗначенияСтавокНДСиНСП()

// Функция - Расчет всех сумм отчета НДС - как основных сумм, например, "050",
//           так и вспомогательных, например, СуммаДоотгрузки или КоэффициентОсвобожденныхПоставок
//
// Параметры:
//  ВидСуммы	- строка - вид расчета суммы. Например, расчет суммы строки отчета "050" или вспомогательной суммы СуммаДоотгрузки
//  Параметры 	- структура - содержит перечень всех используемых данных для каждого вида расчета суммы.
// Возвращаемое значение:
//   - число 	- значение расчитанной суммы
Функция РасчетСуммыОтчетаНДС(ВидСуммы, Знач Параметры) Экспорт
	СтруктураВозврата = Новый Структура;
	РезультатРасчета = 0;
	ТаблицаРасшифровка = Неопределено;
	ТаблицаДетальныеЗаписи = Неопределено;
	
	Если ВидСуммы = "СуммаДоотгрузки" Тогда
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		// Параметры.Таблица - табличная часть Доотгрузка
		Для каждого СтрокаТабличнойЧасти Из Параметры.Таблица Цикл
			РезультатРасчета = РезультатРасчета + СтрокаТабличнойЧасти.Сумма;
			СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТабличнойЧасти);
		КонецЦикла;
		
	ИначеЕсли ВидСуммы = "СуммаНДСДоотгрузки" Тогда
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		// Параметры.Таблица - табличная часть Доотгрузка
		Для каждого СтрокаТабличнойЧасти Из Параметры.Таблица Цикл
			РезультатРасчета = РезультатРасчета + СтрокаТабличнойЧасти.СуммаНДС;
			СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТабличнойЧасти);
		КонецЦикла;
		
	ИначеЕсли ВидСуммы = "СуммаНСПДоотгрузки" Тогда
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		// Параметры.Таблица - табличная часть Доотгрузка
		Для каждого СтрокаТабличнойЧасти Из Параметры.Таблица Цикл
			РезультатРасчета = РезультатРасчета + СтрокаТабличнойЧасти.СуммаНСП;
			СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТабличнойЧасти);
		КонецЦикла;	
		
	ИначеЕсли ВидСуммы = "СуммаДоотгрузкаНулеваяСтавка" Тогда
		// Параметры.Таблица - табличная часть Доотгрузка 
		Для каждого СтрокаТабличнойЧасти Из Параметры.Таблица Цикл
			РезультатРасчета = РезультатРасчета + СтрокаТабличнойЧасти.Сумма;
		КонецЦикла;
		
	ИначеЕсли ВидСуммы = "СуммаНДСДоотгрузкаНулеваяСтавка" Тогда
		// Параметры.Таблица - табличная часть Доотгрузка 
		Для каждого СтрокаТабличнойЧасти Из Параметры.Таблица Цикл
			РезультатРасчета = РезультатРасчета + СтрокаТабличнойЧасти.СуммаНДС;
		КонецЦикла;
				
	ИначеЕсли ВидСуммы = "СуммаДоотгрузкаОсвобожденнаяСтавка" Тогда
		// Параметры.Таблица - табличная часть Доотгрузка 
		Для каждого СтрокаТабличнойЧасти Из Параметры.Таблица Цикл
			РезультатРасчета = РезультатРасчета + СтрокаТабличнойЧасти.Сумма;
		КонецЦикла;		
						
	ИначеЕсли ВидСуммы = "СуммаНДСДоотгрузкаОсвобожденнаяСтавка" Тогда
		// Параметры.Таблица - табличная часть Доотгрузка 
		Для каждого СтрокаТабличнойЧасти Из Параметры.Таблица Цикл
			РезультатРасчета = РезультатРасчета + СтрокаТабличнойЧасти.СуммаНДС;
		КонецЦикла;		
		
	ИначеЕсли ВидСуммы = "СуммаАвансы" Тогда
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		// Параметры.Таблица - табличная часть Авансы 
		Для каждого СтрокаТабличнойЧасти Из Параметры.Таблица Цикл
			Если СтрокаТабличнойЧасти.СтавкаНДС <> Справочники.СтавкиНДС.Нулевая Тогда
				Если СтрокаТабличнойЧасти.СуммаДокумента <> 0 Тогда
					РезультатРасчета = РезультатРасчета + СтрокаТабличнойЧасти.Сумма;
					СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТабличнойЧасти);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ВидСуммы = "СуммаНДСАвансы" Тогда
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		// Параметры.Таблица - табличная часть Авансы 
		Для каждого СтрокаТабличнойЧасти Из Параметры.Таблица Цикл
			Если СтрокаТабличнойЧасти.СтавкаНДС <> Справочники.СтавкиНДС.Нулевая Тогда
				Если СтрокаТабличнойЧасти.СуммаДокумента <> 0 Тогда
					РезультатРасчета = РезультатРасчета + СтрокаТабличнойЧасти.СуммаНДС;
					СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТабличнойЧасти);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ВидСуммы = "СуммаНСПАвансы" Тогда
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		// Параметры.Таблица - табличная часть Авансы 
		Для каждого СтрокаТабличнойЧасти Из Параметры.Таблица Цикл
			Если СтрокаТабличнойЧасти.СтавкаНДС <> Справочники.СтавкиНДС.Нулевая Тогда
				Если СтрокаТабличнойЧасти.СуммаДокумента <> 0 Тогда
					РезультатРасчета = РезультатРасчета + СтрокаТабличнойЧасти.СуммаНСП;
					СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТабличнойЧасти);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ВидСуммы = "СуммаАвансыНулеваяСтавка" Тогда
		// Параметры.Таблица - табличная часть Авансы 
		Для каждого СтрокаТабличнойЧасти Из Параметры.Таблица Цикл
			Если СтрокаТабличнойЧасти.СтавкаНДС = Справочники.СтавкиНДС.Нулевая Тогда
				Если СтрокаТабличнойЧасти.СуммаДокумента <> 0 Тогда
					РезультатРасчета = РезультатРасчета + СтрокаТабличнойЧасти.Сумма;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ВидСуммы = "СуммаНДСАвансыНулеваяСтавка" Тогда
		// Параметры.Таблица - табличная часть Авансы 
		Для каждого СтрокаТабличнойЧасти Из Параметры.Таблица Цикл
			Если СтрокаТабличнойЧасти.СтавкаНДС = Справочники.СтавкиНДС.Нулевая Тогда
				Если СтрокаТабличнойЧасти.СуммаДокумента <> 0 Тогда
					РезультатРасчета = РезультатРасчета + СтрокаТабличнойЧасти.СуммаНДС;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
				
	ИначеЕсли ВидСуммы = "СуммаАвансыОсвобожденнаяСтавка" Тогда
		// Параметры.Таблица - табличная часть Авансы 
		Для каждого СтрокаТабличнойЧасти Из Параметры.Таблица Цикл
			Если СтрокаТабличнойЧасти.СтавкаНДС = Справочники.СтавкиНДС.Освобожденная Тогда
				Если СтрокаТабличнойЧасти.СуммаДокумента <> 0 Тогда
					РезультатРасчета = РезультатРасчета + СтрокаТабличнойЧасти.Сумма;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;		
						
	ИначеЕсли ВидСуммы = "СуммаНДСАвансыОсвобожденнаяСтавка" Тогда
		// Параметры.Таблица - табличная часть Авансы 
		Для каждого СтрокаТабличнойЧасти Из Параметры.Таблица Цикл
			Если СтрокаТабличнойЧасти.СтавкаНДС = Справочники.СтавкиНДС.Освобожденная Тогда
				Если СтрокаТабличнойЧасти.СуммаДокумента <> 0 Тогда
					РезультатРасчета = РезультатРасчета + СтрокаТабличнойЧасти.СуммаНДС;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;		
						
	ИначеЕсли ВидСуммы = "СуммаПродажОбщая" Тогда
		// Параметры.Таблица - таблица значений из РС Сведения о реализации 
		РезультатРасчета  = Параметры.Таблица.Итог("СуммаБезНДС") + Параметры.СуммаАвансы - Параметры.СуммаДоотгрузки;		
						
	ИначеЕсли ВидСуммы = "СуммаПродажОсвобожденная" Тогда
		// Параметры.Таблица - таблица значений из РС Сведения о реализации
		Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл		
			Если СтрокаТаблицыЗначений.СтавкаНДС = Справочники.СтавкиНДС.Освобожденная Тогда
				РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаБезНДС;
			КонецЕсли;					
		КонецЦикла;		
		 РезультатРасчета = РезультатРасчета + Параметры.СуммаАвансы - Параметры.СуммаДоотгрузки;
						
	ИначеЕсли ВидСуммы = "КоэффициентОсвобожденныхПоставокРасчетный" Тогда
		
		Сумма053 = Параметры.Сумма053;
		
		Сумма054 = Параметры.Сумма054 - (Параметры.СуммаАвансы - Параметры.СуммаНДСАвансы - Параметры.СуммаНСПАвансы) 
							+ (Параметры.СуммаДоотгрузки - Параметры.СуммаНДСДоотгрузки - Параметры.СуммаНСПДоотгрузки);							
		
		Если Сумма054 = 0 Тогда
			КоэффициентОсвобожденныхПоставок = 0;
		Иначе
			КоэффициентОсвобожденныхПоставок = Окр(Сумма053 / Сумма054, 4);
		КонецЕсли;
		
		Если КоэффициентОсвобожденныхПоставок <= (Параметры.ПороговыйПроцентОсвобожденныхПоставок / 100) 
			ИЛИ КоэффициентОсвобожденныхПоставок = 0 Тогда
			КоэффициентОсвобожденныхПоставокРасчетный = 0;
		Иначе
			КоэффициентОсвобожденныхПоставокРасчетный = КоэффициентОсвобожденныхПоставок;
		КонецЕсли;	
		
		РезультатРасчета = КоэффициентОсвобожденныхПоставокРасчетный;
		
	ИначеЕсли ВидСуммы = "НДСДляРаспределения" Тогда
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, СуммаНДС");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		Если Параметры.УказыватьПризнакЗачетаНДСПриПоступлении Тогда
			Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
				Если СтрокаТаблицыЗначений.ЗачетНДС = Перечисления.ВидыЗачетаНДС.Распределение Тогда
					РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаНДС;
					СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
					СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
				КонецЕсли;
			КонецЦикла;
		Иначе
			Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
				РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаНДС;
				СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
				СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
			КонецЦикла;
		КонецЕсли;	
		
	ИначеЕсли ВидСуммы = "НДСДляРаспределенияКР" Тогда
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, СуммаНДС");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		Если Параметры.УказыватьПризнакЗачетаНДСПриПоступлении Тогда
			Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
				Если СтрокаТаблицыЗначений.ЗачетНДС = Перечисления.ВидыЗачетаНДС.Распределение 
					И СтрокаТаблицыЗначений.ПризнакСтраны = Перечисления.ПризнакиСтраны.КР Тогда
					РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаНДС;
					СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
					СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
				КонецЕсли;
			КонецЦикла;
		Иначе
			Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
				Если СтрокаТаблицыЗначений.ПризнакСтраны = Перечисления.ПризнакиСтраны.КР Тогда
					РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаНДС;
					СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
					СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли ВидСуммы = "НДСДляРаспределенияЕАЭС" Тогда
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, СуммаНДС");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		Если Параметры.УказыватьПризнакЗачетаНДСПриПоступлении Тогда
			Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
				Если СтрокаТаблицыЗначений.ЗачетНДС = Перечисления.ВидыЗачетаНДС.Распределение 
					И СтрокаТаблицыЗначений.ПризнакСтраны = Перечисления.ПризнакиСтраны.ЕАЭС Тогда
					РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаНДС;
					СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
					СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
				КонецЕсли;
			КонецЦикла;
		Иначе
			Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
				Если СтрокаТаблицыЗначений.ПризнакСтраны = Перечисления.ПризнакиСтраны.ЕАЭС Тогда
					РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаНДС;
					СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
					СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли ВидСуммы = "НДСДляРаспределенияНеКР" Тогда
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, СуммаНДС");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		Если Параметры.УказыватьПризнакЗачетаНДСПриПоступлении Тогда
			Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
				Если СтрокаТаблицыЗначений.ЗачетНДС = Перечисления.ВидыЗачетаНДС.Распределение 
					И НЕ СтрокаТаблицыЗначений.ПризнакСтраны = Перечисления.ПризнакиСтраны.КР Тогда
					РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаНДС;
					СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
					СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
				КонецЕсли;
			КонецЦикла;
		Иначе
			Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
				Если НЕ СтрокаТаблицыЗначений.ПризнакСтраны = Перечисления.ПризнакиСтраны.КР Тогда
					РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаНДС;
					СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
					СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;	
		
	ИначеЕсли ВидСуммы = "НДСКРСебестоимость" Тогда
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, СуммаНДС");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		Если Параметры.УказыватьПризнакЗачетаНДСПриПоступлении Тогда
			Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
				Если СтрокаТаблицыЗначений.ЗачетНДС = Перечисления.ВидыЗачетаНДС.Себестоимость 
					И СтрокаТаблицыЗначений.ПризнакСтраны = Перечисления.ПризнакиСтраны.КР Тогда
					РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаНДС;
					СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
					СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
				КонецЕсли;
			КонецЦикла;
		Иначе
			РезультатРасчета = 0;		
		КонецЕсли;
		
	ИначеЕсли ВидСуммы = "НДСЕАЭССебестоимость" Тогда
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, СуммаНДС");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		Если Параметры.УказыватьПризнакЗачетаНДСПриПоступлении Тогда
			Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
				Если СтрокаТаблицыЗначений.ЗачетНДС = Перечисления.ВидыЗачетаНДС.Себестоимость 
					И СтрокаТаблицыЗначений.ПризнакСтраны = Перечисления.ПризнакиСтраны.ЕАЭС Тогда
					РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаНДС;
					СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
					СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
				КонецЕсли;
			КонецЦикла;
		Иначе
			РезультатРасчета = 0;		
		КонецЕсли;
		
	ИначеЕсли ВидСуммы = "НДСНеКРСебестоимость" Тогда
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, СуммаНДС");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		Если Параметры.УказыватьПризнакЗачетаНДСПриПоступлении Тогда
			Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
				Если СтрокаТаблицыЗначений.ЗачетНДС = Перечисления.ВидыЗачетаНДС.Себестоимость 
					И НЕ СтрокаТаблицыЗначений.ПризнакСтраны = Перечисления.ПризнакиСтраны.КР Тогда
					РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаНДС;
					СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
					СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
				КонецЕсли;
			КонецЦикла;
		Иначе
			РезультатРасчета = 0;		
		КонецЕсли;
		
	ИначеЕсли ВидСуммы = "НДСКРНеРазрешенныйКЗачету" Тогда
		РезультатРасчета = Окр(Параметры.КфОПР * Параметры.НДСДляРаспределенияКР + Параметры.НДСКРСебестоимость, 2);
		
	ИначеЕсли ВидСуммы = "НДСЕАЭСНеРазрешенныйКЗачету" Тогда
		РезультатРасчета = Окр(Параметры.КфОПР * Параметры.НДСДляРаспределенияЕАЭС + Параметры.НДСЕАЭССебестоимость, 2);
		
	ИначеЕсли ВидСуммы = "НДСНеКРНеРазрешенныйКЗачету" Тогда
		РезультатРасчета = Окр(Параметры.КфОПР * Параметры.НДСДляРаспределенияНеКР + Параметры.НДСНеКРСебестоимость, 2);		
		
	ИначеЕсли ВидСуммы = "Сумма050" Тогда
		// Параметры.Таблица - таблица значений из РС Сведения о реализации
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, СуммаБезНДС");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		ТаблицаСтавок = ПолучитьСтавкиНДССНулевымиЗначениями(Параметры.Период);
		СтруктураПоиска = Новый Структура();
		СтруктураПоиска.Вставить("СтавкаНДС", Справочники.СтавкиНДС.ПустаяСсылка());
		
		Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл	
			СтруктураПоиска.СтавкаНДС = СтрокаТаблицыЗначений.СтавкаНДС;
			МассивСтавок = ТаблицаСтавок.НайтиСтроки(СтруктураПоиска);
			
			Если МассивСтавок.Количество() = 0 И СтрокаТаблицыЗначений.ПризнакСтраны = Перечисления.ПризнакиСтраны.КР Тогда
				РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаБезНДС;
				СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
				СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
			КонецЕсли;
		КонецЦикла;
		СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
		СтрокаРасшифровки.Регистратор = "Авансы";
		СтрокаРасшифровки.СуммаБезНДС = Параметры.СуммаАвансы;
		
		СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
		СтрокаРасшифровки.Регистратор = "АвансыНДС";
		СтрокаРасшифровки.СуммаБезНДС = Параметры.СуммаНДСАвансы;
		
		СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
		СтрокаРасшифровки.Регистратор = "АвансыНСП";
		СтрокаРасшифровки.СуммаБезНДС = Параметры.СуммаНСПАвансы;
		
		СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
		СтрокаРасшифровки.Регистратор = "Доотгрузка";
		СтрокаРасшифровки.СуммаБезНДС = Параметры.СуммаДоотгрузки;
		
		СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
		СтрокаРасшифровки.Регистратор = "ДоотгрузкаНДС";
		СтрокаРасшифровки.СуммаБезНДС = Параметры.СуммаНДСДоотгрузки;
		
		СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
		СтрокаРасшифровки.Регистратор = "ДоотгрузкаНСП";
		СтрокаРасшифровки.СуммаБезНДС = Параметры.СуммаНСПДоотгрузки;
		
		РезультатРасчета = РезультатРасчета + Параметры.СуммаАвансы - Параметры.СуммаНДСАвансы - Параметры.СуммаНСПАвансы 
							- (Параметры.СуммаДоотгрузки - Параметры.СуммаНДСДоотгрузки - Параметры.СуммаНСПДоотгрузки);
		
	ИначеЕсли ВидСуммы = "Сумма051" Тогда
		// Параметры.Таблица - таблица значений из РС Сведения о реализации
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, СуммаБезНДС");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
			Если СтрокаТаблицыЗначений.СтавкаНДС = Справочники.СтавкиНДС.Нулевая Тогда
				РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаБезНДС;
				СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);	
				СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
			КонецЕсли;
		КонецЦикла;	
						
	ИначеЕсли ВидСуммы = "Сумма052" Тогда
		// Параметры.Таблица - таблица значений из РС Сведения о реализации
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, СуммаБезНДС");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
			Если СтрокаТаблицыЗначений.СтавкаНДС = Справочники.СтавкиНДС.Нулевая 
				И СтрокаТаблицыЗначений.ПризнакСтраны = Перечисления.ПризнакиСтраны.ЕАЭС Тогда
				РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаБезНДС;
				СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
				СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ВидСуммы = "Сумма053" Тогда
		// Параметры.Таблица - таблица значений из РС Сведения о реализации
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, СуммаБезНДС");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		ТаблицаСтавок = ПолучитьСтавкиНДССНулевымиЗначениями(Параметры.Период);
		СтруктураПоиска = Новый Структура();
		СтруктураПоиска.Вставить("СтавкаНДС", Справочники.СтавкиНДС.ПустаяСсылка());
		
		СуммаБезНДССтавокСНулями = 0;
		СуммаБезНДСНулевойСтавки = 0;
		
		Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
			СтруктураПоиска.СтавкаНДС = СтрокаТаблицыЗначений.СтавкаНДС;
			МассивСтавок = ТаблицаСтавок.НайтиСтроки(СтруктураПоиска);
			
			Если МассивСтавок.Количество() <> 0 Тогда
				// СуммаБезНДС всех ставок с значением 0
				СуммаБезНДССтавокСНулями = СуммаБезНДССтавокСНулями + СтрокаТаблицыЗначений.СуммаБезНДС;
				СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
				СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
			КонецЕсли;	
			
			Если СтрокаТаблицыЗначений.СтавкаНДС = Справочники.СтавкиНДС.Нулевая Тогда
				СуммаБезНДСНулевойСтавки = СуммаБезНДСНулевойСтавки + СтрокаТаблицыЗначений.СуммаБезНДС;
				СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);	
				СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
			КонецЕсли;
		КонецЦикла;	
		
		РезультатРасчета = СуммаБезНДССтавокСНулями - СуммаБезНДСНулевойСтавки;
								
	ИначеЕсли ВидСуммы = "Сумма054" Тогда
		// Параметры - суммы ранее расчитанных строк 050, 051 и 053 	
		РезультатРасчета = Параметры.Сумма050 + Параметры.Сумма051 + Параметры.Сумма053;		
								
	ИначеЕсли ВидСуммы = "Сумма055" Тогда
		// Параметры.Таблица - таблица значений из РС Сведения о поступлении
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, Сумма");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
			Если СтрокаТаблицыЗначений.ПризнакСтраны = Перечисления.ПризнакиСтраны.КР  Тогда
				РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.Сумма;
				СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
				СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
			КонецЕсли;
		КонецЦикла;		
								
	ИначеЕсли ВидСуммы = "Сумма056" Тогда
		// Параметры.Таблица - таблица значений из РС Сведения о поступлении
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, Сумма");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
			Если НЕ СтрокаТаблицыЗначений.ПризнакСтраны = Перечисления.ПризнакиСтраны.КР Тогда
				РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.Сумма;
				СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);	
				СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
			КонецЕсли;
		КонецЦикла;			
								
	ИначеЕсли ВидСуммы = "Сумма057" Тогда
		// Параметры.Таблица - таблица значений из РС Сведения о поступлении
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, Сумма");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
			Если СтрокаТаблицыЗначений.ПризнакСтраны = Перечисления.ПризнакиСтраны.ЕАЭС Тогда
				РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.Сумма;
				СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
				СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
			КонецЕсли;
		КонецЦикла;		
									
	ИначеЕсли ВидСуммы = "Сумма058" Тогда
		// Параметры - суммы ранее расчитанных строк 055 и 056
		РезультатРасчета = Параметры.Сумма055 + Параметры.Сумма056;
	
	ИначеЕсли ВидСуммы = "Сумма059" Тогда
		// Параметры.Таблица - таблица значений из РС Сведения о реализации
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, СуммаНДС");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
		
		Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
			РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаНДС;
			СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);	
			СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
		КонецЦикла;
		СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
		СтрокаРасшифровки.Регистратор = "Авансы";
		СтрокаРасшифровки.СуммаНДС = Параметры.СуммаНДСАвансы;
		
		СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
		СтрокаРасшифровки.Регистратор = "Доотгрузка";
		СтрокаРасшифровки.СуммаНДС = -Параметры.СуммаНДСДоотгрузки;
		
		РезультатРасчета = РезультатРасчета + Параметры.СуммаНДСАвансы - Параметры.СуммаНДСДоотгрузки;						
		
	//НДС ЗА ПРИОБРЕТЕННЫЕ МАТЕРИАЛЬНЫЕ РЕСУРСЫ, ПОДЛЕЖАЩИЙ ЗАЧЕТУ		
	//
	ИначеЕсли ВидСуммы = "Сумма060" Тогда
		// Параметры.Таблица - таблица значений из РС Сведения о поступлении
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, СуммаНДС");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
 
		Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
			Если СтрокаТаблицыЗначений.ПризнакСтраны = Перечисления.ПризнакиСтраны.КР Тогда
				РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаНДС;
				СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
				СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
			КонецЕсли;
		КонецЦикла;						

		РезультатРасчета = РезультатРасчета - Параметры.НДСКРНеРазрешенныйКЗачету;
		
	// НДС НА ИМПОРТ ПОДЛЕЖАЩИЙ ЗАЧЕТУ
	//
	ИначеЕсли ВидСуммы = "Сумма061" Тогда
		// Параметры.Таблица - таблица значений из РС Сведения о поступлении
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, СуммаНДС");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
 
		Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
			Если НЕ СтрокаТаблицыЗначений.ПризнакСтраны = Перечисления.ПризнакиСтраны.КР Тогда
				РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаНДС;
				СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
				СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
			КонецЕсли;
		КонецЦикла;						

		РезультатРасчета = РезультатРасчета - Параметры.НДСНеКРНеРазрешенныйКЗачету;		
		
	// В ТОМ ЧИСЛЕ ИЗ ЕВРАЗИЙСКОГО ЭКОНОМИЧЕСКОГО  СОЮЗА
	//
	ИначеЕсли ВидСуммы = "Сумма062" Тогда
		// Параметры.Таблица - таблица значений из РС Сведения о поступлении
		ТаблицаРасшифровка = Параметры.Таблица.СкопироватьКолонки("Регистратор, СуммаНДС");
		ТаблицаДетальныеЗаписи = Параметры.Таблица.СкопироватьКолонки();
 
		Для каждого СтрокаТаблицыЗначений Из Параметры.Таблица Цикл
			Если СтрокаТаблицыЗначений.ПризнакСтраны = Перечисления.ПризнакиСтраны.ЕАЭС Тогда
				РезультатРасчета = РезультатРасчета + СтрокаТаблицыЗначений.СуммаНДС;
				СтрокаРасшифровки = ТаблицаРасшифровка.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, СтрокаТаблицыЗначений);
				СтрокаТаблицы = ТаблицаДетальныеЗаписи.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаТаблицыЗначений);
			КонецЕсли;
		КонецЦикла;						

		РезультатРасчета = РезультатРасчета - Параметры.НДСЕАЭСНеРазрешенныйКЗачету;		
		
	// НДС ЗА ПРИОБРЕТЕННЫЕ МАТЕРИАЛЬНЫЕ РЕСУРСЫ, НЕ ПОДЛЕЖАЩИЙ ЗАЧЕТУ
	//
	ИначеЕсли ВидСуммы = "Сумма063" Тогда
		РезультатРасчета = Параметры.НДСКРНеРазрешенныйКЗачету + Параметры.НДСНеКРНеРазрешенныйКЗачету;				
				
	//НДС ЗА ПРИОБРЕТЕННЫЕ МАТЕРИАЛЬНЫЕ РЕСУРСЫ, ПОДЛЕЖАЩИЙ ЗАЧЕТУ		
	//
	ИначеЕсли ВидСуммы = "Сумма064" Тогда
		// Параметры - суммы ранне расчитанных строк 060 и 061
		РезультатРасчета = Параметры.Сумма060 + Параметры.Сумма061;				
		
	// В ТОМ ЧИСЛЕ НДС ЗА ПРИОБРЕТЕННЫЕ МАТЕРИАЛЬНЫЕ РЕСУРСЫ, ИСПОЛЬЗУЕМЫЕ ДЛЯ ПОСТАВОК С НУЛЕВОЙ СТАВКОЙ
	//
	ИначеЕсли ВидСуммы = "Сумма065" Тогда
		// Параметры - умножение коэфициента нулевых поставок (КфНП) и ранее расчитанной строки 064
		Сумма = Параметры.Сумма050 + Параметры.Сумма051;
		
		Если Сумма = 0 ИЛИ Параметры.Сумма051 = 0 Тогда
			РезультатРасчета = 0;
		Иначе
			КфНП = Окр(Параметры.Сумма051 / (Сумма), 4);
			РезультатРасчета = Окр(КфНП * Параметры.Сумма064, 2);
		КонецЕсли;
		
	// НАЛОГОВОЕ ОБЯЗАТЕЛЬСТВО (=059-064) (УКАЖИТЕ ЗНАК МИНУС, ЕСЛИ ЗНАЧЕНИЕ ОТРИЦАТЕЛЬНОЕ)
	//
	ИначеЕсли ВидСуммы = "Сумма066" Тогда
		// Параметры - разность ранне расчитанных строк 059 и 064
		РезультатРасчета = Параметры.Сумма059 - Параметры.Сумма064;		
		
	// НАЛОГОВОЕ ОБЯЗАТЕЛЬСТВО ВСЕГО (=066-067) (УКАЖИТЕ ЗНАК МИНУС, ЕСЛИ ЗНАЧЕНИЕ ОТРИЦАТЕЛЬНОЕ)
	//
	ИначеЕсли ВидСуммы = "Сумма068" Тогда
		// Параметры - разность ранне расчитанных строк 066 и 067
		РезультатРасчета = Параметры.Сумма066 - Параметры.Сумма067;
		
	ИначеЕсли ВидСуммы = "КфНП" Тогда
		Сумма = Параметры.Сумма050 + Параметры.Сумма051;
		
		Если Сумма = 0 ИЛИ Параметры.Сумма051 = 0 Тогда
			РезультатРасчета = 0;
		Иначе
			РезультатРасчета = Окр(Параметры.Сумма051 / (Сумма), 4);
		КонецЕсли;	
	Иначе
	    РезультатРасчета = 0;           			
	КонецЕсли;
	
	СтруктураВозврата.Вставить("РезультатРасчета", 			РезультатРасчета);
	СтруктураВозврата.Вставить("ТаблицаРасшифровка", 		ТаблицаРасшифровка);
	СтруктураВозврата.Вставить("ТаблицаДетальныеЗаписи", 	ТаблицаДетальныеЗаписи);
	
	Возврат СтруктураВозврата;
	
КонецФункции // РасчетСуммыОТчетаНДС()

Функция ПолучитьСтавкиНДССНулевымиЗначениями(Период) Экспорт

	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтавкиНДССрезПоследних.СтавкаНДС КАК СтавкаНДС
		|ИЗ
		|	РегистрСведений.СтавкиНДС.СрезПоследних(
		|			&Период,
		|			Ставка = 0) КАК СтавкиНДССрезПоследних";
	Запрос.УстановитьПараметр("Период", Период);
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции // ПолучитьСтавкиНДССНулевымиЗначениями()

Функция ВсеСведенияОРеализации(Организация, НачалоМесяца, КонецМесяца, НеУчитыватьЗакупкиБезНДС, ОтчетПоНДСПоПоставке) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СчетаФактурыВыписанные.Регистратор КАК Регистратор,
		|	СчетаФактурыВыписанные.Организация КАК Организация,
		|	СчетаФактурыВыписанные.Контрагент КАК Контрагент,
		|	СчетаФактурыВыписанные.Контрагент.ПризнакСтраны КАК ПризнакСтраны,
		|	СчетаФактурыВыписанные.ДатаПоставки КАК ДатаПоставки,
		|	СчетаФактурыВыписанные.СтавкаНДС КАК СтавкаНДС,
		|	СУММА(СчетаФактурыВыписанные.СуммаБезНДС) КАК СуммаБезНДС,
		|	СУММА(СчетаФактурыВыписанные.СуммаНДС) КАК СуммаНДС,
		|	СУММА(СчетаФактурыВыписанные.СуммаБезНДС + СчетаФактурыВыписанные.СуммаНДС) КАК Всего,
		|	СчетаФактурыВыписанные.Документ КАК ДокументРеализации,
		|	СчетаФактурыВыписанные.Дата КАК Период,
		|	СчетаФактурыВыписанные.СерияБланкаСФ КАК СерияБланкаСФ
		|ИЗ
		|	РегистрСведений.СчетаФактурыВыписанные КАК СчетаФактурыВыписанные
		|ГДЕ
		|	ВЫБОР
		|		КОГДА &ОтчетПоНДСПоПоставке
		|			ТОГДА СчетаФактурыВыписанные.Дата МЕЖДУ &НачалоМесяца И &КонецМесяца
		|		ИНАЧЕ СчетаФактурыВыписанные.ДатаСФ МЕЖДУ &НачалоМесяца И &КонецМесяца
		|	КОНЕЦ
		|	И СчетаФактурыВыписанные.Организация = &Организация
		|	И ВЫБОР
		|			КОГДА &НеУчитыватьЗакупкиБезНДС
		|				ТОГДА СчетаФактурыВыписанные.СуммаНДС <> 0
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|	И СчетаФактурыВыписанные.СерияБланкаСФ <> """"
		|
		|СГРУППИРОВАТЬ ПО
		|	СчетаФактурыВыписанные.Организация,
		|	СчетаФактурыВыписанные.Контрагент,
		|	СчетаФактурыВыписанные.Регистратор,
		|	СчетаФактурыВыписанные.ДатаПоставки,
		|	СчетаФактурыВыписанные.СтавкаНДС,
		|	СчетаФактурыВыписанные.Документ,
		|	СчетаФактурыВыписанные.Дата,
		|	СчетаФактурыВыписанные.СерияБланкаСФ,
		|	СчетаФактурыВыписанные.Контрагент.ПризнакСтраны";
	
	Запрос.УстановитьПараметр("КонецМесяца", 				КонецМесяца);
	Запрос.УстановитьПараметр("НачалоМесяца", 				НачалоМесяца);
	Запрос.УстановитьПараметр("Организация", 				Организация);
	Запрос.УстановитьПараметр("НеУчитыватьЗакупкиБезНДС", 	НеУчитыватьЗакупкиБезНДС);
	Запрос.УстановитьПараметр("ОтчетПоНДСПоПоставке", 		ОтчетПоНДСПоПоставке);
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции // ВсеСведенияОРеализации()

Функция ВсеСведенияОПоступлении(Организация, НачалоМесяца, КонецМесяца, НеУчитыватьЗакупкиБезНДС) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СведенияОПоступлении.Контрагент КАК Контрагент,
		|	СведенияОНДСНаИмпорт.ЗачетНДС КАК ЗачетНДС,
		|	СведенияОНДСНаИмпорт.Сумма КАК Сумма,
		|	СведенияОНДСНаИмпорт.СуммаНДС КАК СуммаНДС,
		|	СведенияОНДСНаИмпорт.Сумма + СведенияОНДСНаИмпорт.СуммаНДС КАК Всего,
		|	СведенияОПоступлении.Контрагент.ПризнакСтраны КАК ПризнакСтраны,
		|	СведенияОПоступлении.Регистратор КАК Регистратор,
		|	СведенияОПоступлении.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	СведенияОПоступлении.НДСНеПодтвержден КАК НДСНеПодтвержден
		|ПОМЕСТИТЬ ВременнаяТаблицаСведенияОНДСНаИмпорт
		|ИЗ
		|	РегистрСведений.СведенияОНДСНаИмпорт КАК СведенияОНДСНаИмпорт
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПоступлении КАК СведенияОПоступлении
		|		ПО СведенияОНДСНаИмпорт.Организация = СведенияОПоступлении.Организация
		|			И СведенияОНДСНаИмпорт.Документ = СведенияОПоступлении.Регистратор
		|ГДЕ
		|	СведенияОНДСНаИмпорт.Дата МЕЖДУ &НачалоМесяца И &КонецМесяца
		|	И СведенияОНДСНаИмпорт.Организация = &Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СведенияОПоступлении.Контрагент КАК Контрагент,
		|	СведенияОПоступлении.ЗачетНДС КАК ЗачетНДС,
		|	СведенияОПоступлении.Сумма КАК Сумма,
		|	СведенияОПоступлении.СуммаНДС КАК СуммаНДС,
		|	СведенияОПоступлении.СуммаНСП КАК СуммаНСП,
		|	СведенияОПоступлении.Сумма + СведенияОПоступлении.СуммаНДС + СведенияОПоступлении.СуммаНСП КАК Всего,
		|	СведенияОПоступлении.Контрагент.ПризнакСтраны КАК ПризнакСтраны,
		|	СведенияОПоступлении.Регистратор КАК Регистратор,
		|	СведенияОПоступлении.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	СведенияОПоступлении.НДСНеПодтвержден КАК НДСНеПодтвержден
		|ИЗ
		|	РегистрСведений.СведенияОПоступлении КАК СведенияОПоступлении
		|ГДЕ
		|	СведенияОПоступлении.ДатаСФ МЕЖДУ &НачалоМесяца И &КонецМесяца
		|	И СведенияОПоступлении.Организация = &Организация
		|	И НЕ СведенияОПоступлении.НДСНеПодтвержден
		|	И ВЫБОР
		|		КОГДА &НеУчитыватьЗакупкиБезНДС
		|			ТОГДА СведенияОПоступлении.СуммаНДС <> 0
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СведенияОНДСНаИмпорт.Контрагент,
		|	СведенияОНДСНаИмпорт.ЗачетНДС,
		|	СведенияОНДСНаИмпорт.Сумма,
		|	СведенияОНДСНаИмпорт.СуммаНДС,
		|	0,
		|	СведенияОНДСНаИмпорт.Сумма + СведенияОНДСНаИмпорт.СуммаНДС,
		|	СведенияОНДСНаИмпорт.Контрагент.ПризнакСтраны,
		|	СведенияОНДСНаИмпорт.Регистратор,
		|	СведенияОНДСНаИмпорт.ДоговорКонтрагента,
		|	СведенияОНДСНаИмпорт.НДСНеПодтвержден
		|ИЗ
		|	ВременнаяТаблицаСведенияОНДСНаИмпорт КАК СведенияОНДСНаИмпорт
		|ГДЕ
		|	ВЫБОР
		|		КОГДА &НеУчитыватьЗакупкиБезНДС
		|			ТОГДА СведенияОНДСНаИмпорт.СуммаНДС <> 0
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ";
	Запрос.УстановитьПараметр("КонецМесяца", 				КонецМесяца);
	Запрос.УстановитьПараметр("НачалоМесяца", 				НачалоМесяца);
	Запрос.УстановитьПараметр("Организация", 				Организация);  
	Запрос.УстановитьПараметр("НеУчитыватьЗакупкиБезНДС", 	НеУчитыватьЗакупкиБезНДС);
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции // ВсеСведенияОРеализации()

#КонецОбласти
