﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаНачисления(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Если Не ДокументСсылка.МетодРасчета.БезСодержания Тогда 
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.ПериодРегистрации,
		|	ТаблицаДокумента.ДатаНачала КАК ПериодДействияНачало,
		|	КОНЕЦПЕРИОДА(ТаблицаДокумента.ДатаОкончания, ДЕНЬ) КАК ПериодДействияКонец,
		|	ТаблицаДокумента.ВидРасчета,
		|	ТаблицаДокумента.СчетУчетаЗатрат,
		|	ТаблицаДокумента.СтатьяЗатрат,
		|	ВременнаяТаблицаШапка.ФизЛицо,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.Подразделение,
		|	ВременнаяТаблицаШапка.Должность,
		|	ТаблицаДокумента.Результат,
		|	ТаблицаДокумента.ОтработаноДней,
		|	ВременнаяТаблицаШапка.ГрафикРаботы,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ПериодРегистрации = ТаблицаДокумента.ПериодРегистрации
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ОтложенноеОтражение
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаНачисления КАК ТаблицаДокумента
		|		ПО (ИСТИНА)";

		РезультатЗапроса = Запрос.Выполнить();
			
	Иначе 
		
		ВременнаяТаблицаНачисленияПоПериодам = Новый ТаблицаЗначений;
		ВременнаяТаблицаНачисленияПоПериодам.Колонки.Добавить("ФизЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
		ВременнаяТаблицаНачисленияПоПериодам.Колонки.Добавить("ГрафикРаботы", Новый ОписаниеТипов("СправочникСсылка.Календари"));
		ВременнаяТаблицаНачисленияПоПериодам.Колонки.Добавить("ДатаНачала", Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты()));
		ВременнаяТаблицаНачисленияПоПериодам.Колонки.Добавить("ДатаОкончания", Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты()));
		ВременнаяТаблицаНачисленияПоПериодам.Колонки.Добавить("ПериодРегистрации", Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты()));
		ВременнаяТаблицаНачисленияПоПериодам.Колонки.Добавить("Дней", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(3,0,ДопустимыйЗнак.Неотрицательный)));
		ВременнаяТаблицаНачисленияПоПериодам.Колонки.Добавить("Часов", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(7,2,ДопустимыйЗнак.Неотрицательный)));
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.ФизЛицо,
		|	ВременнаяТаблицаШапка.ДатаНачала КАК ДатаНачала,
		|	ВременнаяТаблицаШапка.ДатаОкончания КАК ДатаОкончания,
		|	ВременнаяТаблицаШапка.РасчетПоРабочимДням КАК РасчетПоРабочимДням,
		|	ВременнаяТаблицаШапка.ГрафикРаботы,
		|	ВременнаяТаблицаШапка.Дней,
		|	ВременнаяТаблицаШапка.Часов
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка";
		РезультатЗапроса = Запрос.Выполнить();	
		Выборка = РезультатЗапроса.Выбрать();	
		
		//Рассчет часов по дате начала и окончания
		
		Пока Выборка.Следующий() Цикл 
			ПериодРегистрацииДатаОкончания = НачалоМесяца(Выборка.ДатаОкончания);
			Дней = Выборка.Дней;
			Часов = Выборка.Часов;

			Шаг = 0;
			Пока Истина Цикл 
				СтрокаТаблицы = ВременнаяТаблицаНачисленияПоПериодам.Добавить();
				СтрокаТаблицы.ФизЛицо = Выборка.ФизЛицо;
				СтрокаТаблицы.ГрафикРаботы = Выборка.ГрафикРаботы;
				
				СтрокаТаблицы.ДатаНачала = ?(Шаг = 0,  
				Выборка.ДатаНачала, 
				НачалоМесяца(ДобавитьМесяц(Выборка.ДатаНачала, Шаг)));
				
				СтрокаТаблицы.ПериодРегистрации = НачалоМесяца(СтрокаТаблицы.ДатаНачала);
				
				СтрокаТаблицы.ДатаОкончания = ?(СтрокаТаблицы.ПериодРегистрации = ПериодРегистрацииДатаОкончания, 
				Выборка.ДатаОкончания, 
				КонецМесяца(ДобавитьМесяц(Выборка.ДатаНачала, Шаг)));
				
				СтруктураКоличествоДней = ПроведениеРасчетовПоЗарплатеСервер.КоличествоДнейГрафикаРаботы(Выборка.ГрафикРаботы, СтрокаТаблицы.ДатаНачала, КонецДня(СтрокаТаблицы.ДатаОкончания));		
				КоличествоДней = Мин(?(Выборка.РасчетПоРабочимДням, 
				СтруктураКоличествоДней.КоличествоДнейБезПраздник - СтруктураКоличествоДней.КоличествоДнейВоскресенье - СтруктураКоличествоДней.КоличествоДнейВыходной, 
				СтруктураКоличествоДней.КоличествоДней), Дней);	
				
				КоличествоЧасов = ?(Выборка.РасчетПоРабочимДням,СтруктураКоличествоДней.КоличествоЧасовБезПраздник - СтруктураКоличествоДней.КоличествоЧасовВыходной, Часов); 
		
				СтрокаТаблицы.Дней = КоличествоДней;				
				СтрокаТаблицы.Часов = КоличествоЧасов;
				
				Дней = Дней - КоличествоДней; 
				Часов= Часов - КоличествоЧасов;
				
				Если СтрокаТаблицы.ПериодРегистрации = ПериодРегистрацииДатаОкончания Тогда 
					Прервать;
				КонецЕсли;	
				
				Шаг = Шаг + 1;			
			КонецЦикла;	
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаНачисленияПоПериодам.ФизЛицо,
		|	ВременнаяТаблицаНачисленияПоПериодам.ГрафикРаботы,
		|	ВременнаяТаблицаНачисленияПоПериодам.ДатаНачала,
		|	ВременнаяТаблицаНачисленияПоПериодам.ДатаОкончания,
		|	ВременнаяТаблицаНачисленияПоПериодам.ПериодРегистрации,
		|	ВременнаяТаблицаНачисленияПоПериодам.Дней,
		|	ВременнаяТаблицаНачисленияПоПериодам.Часов
		|ПОМЕСТИТЬ ВременнаяТаблицаНачисленияПоПериодам
		|ИЗ
		|	&ВременнаяТаблицаНачисленияПоПериодам КАК ВременнаяТаблицаНачисленияПоПериодам
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ПериодРегистрации,
		|	ТаблицаДокумента.ДатаНачала КАК ПериодДействияНачало,
		|	КОНЕЦПЕРИОДА(ТаблицаДокумента.ДатаОкончания, ДЕНЬ) КАК ПериодДействияКонец,
		|	ВременнаяТаблицаШапка.ВидРасчета,
		|	ТаблицаДокумента.ФизЛицо,
		|	ВременнаяТаблицаШапка.Организация,
		|	ТаблицаДокумента.Дней КАК ОтработаноДней,
		|	ТаблицаДокумента.Часов КАК ОтработаноЧасов,
		|	ТаблицаДокумента.ГрафикРаботы КАК ГрафикРаботы
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаНачисленияПоПериодам КАК ТаблицаДокумента
		|		ПО (ИСТИНА)";
		Запрос.УстановитьПараметр("ВременнаяТаблицаНачисленияПоПериодам", ВременнаяТаблицаНачисленияПоПериодам);
		
		РезультатЗапроса = Запрос.Выполнить();
	КонецЕсли;
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаНачисления", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаНачисления()

//// Формирует таблицу значений, содержащую данные для проведения по регистру.
//// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
////
//Процедура СформироватьТаблицаОстаткиДнейОтпуска(ДокументСсылка, СтруктураДополнительныеСвойства)
//	
//	Запрос = Новый Запрос;
//	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
//	Запрос.Текст =
//	"ВЫБРАТЬ
//	|	ВременнаяТаблицаШапка.Дата КАК Период,
//	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,	
//	|	ВременнаяТаблицаШапка.ФизЛицо,
//	|	ВременнаяТаблицаШапка.ДатаНачалаРабочегоГода КАК ПериодОтпуска,
//	|	ТаблицаДокумента.КоличествоДней - ТаблицаДокумента.КоличествоДнейФакт КАК Количество,
//	|	ТаблицаДокумента.ВидОтпуска
//	|ИЗ
//	|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
//	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаДополнительныеОтпуска КАК ТаблицаДокумента
//	|		ПО (ИСТИНА)";

//	РезультатЗапроса = Запрос.Выполнить();
//	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОстаткиДнейОтпуска", РезультатЗапроса.Выгрузить());
//КонецПроцедуры // СформироватьТаблицаОстаткиДнейОтпуска()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаИспользованиеДнейОтпуска(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВременнаяТаблицаШапка.Дата КАК Период,
	|	ВременнаяТаблицаШапка.ФизЛицо,
	|	ВременнаяТаблицаШапка.ДатаНачалаРабочегоГода КАК ПериодОтпуска,
	|	ТаблицаДокумента.КоличествоДнейФакт КАК Количество,
	|	ТаблицаДокумента.ВидОтпуска
	|ИЗ
	|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаДополнительныеОтпуска КАК ТаблицаДокумента
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ТаблицаДокумента.КоличествоДнейФакт > 0";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаИспользованиеДнейОтпуска", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаИспользованиеДнейОтпуска()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаВзаиморасчетыССотрудниками(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаДокумента.ПериодРегистрации КАК Период,
	|	ВременнаяТаблицаШапка.Организация,
	|	ВременнаяТаблицаШапка.ФизЛицо,
	|	ТаблицаДокумента.Результат КАК Сумма
	|ИЗ
	|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаНачисления КАК ТаблицаДокумента
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ТаблицаДокумента.Результат <> 0";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаВзаиморасчетыССотрудниками", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаСотрудники()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Дата,
	|	НАЧАЛОПЕРИОДА(ТаблицаДокумента.Дата, МЕСЯЦ) КАК ПериодРегистрации,
	|	ТаблицаДокумента.Организация,
	|	ТаблицаДокумента.ФизЛицо,
	|	ТаблицаДокумента.Подразделение,
	|	ТаблицаДокумента.Должность,
	|	ТаблицаДокумента.ГрафикРаботы,
	|	ТаблицаДокумента.МетодРасчета.ВидРасчета КАК ВидРасчета,
	|	ТаблицаДокумента.Дней,
	|	ТаблицаДокумента.Часов,
	|	ТаблицаДокумента.ДнейДополнительногоОтпуска,
	|	ТаблицаДокумента.ДатаНачала,
	|	ТаблицаДокумента.ДатаОкончания,
	|	ТаблицаДокумента.ВидОперации,
	|	ТаблицаДокумента.ДатаНачалаРабочегоГода,
	|	ТаблицаДокумента.ДатаОкончанияРабочегоГода,
	|	ТаблицаДокумента.МетодРасчета.РасчетПоРабочимДням КАК РасчетПоРабочимДням,
	|	ТаблицаДокумента.МетодРасчета,
	|	&Результат КАК Результат
	|ПОМЕСТИТЬ ВременнаяТаблицаШапка
	|ИЗ
	|	Документ.Отпуск КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.ПериодРегистрации,
	|	ТаблицаДокумента.ДатаНачала,
	|	ТаблицаДокумента.ВидРасчета,
	|	ТаблицаДокумента.ДатаОкончания,
	|	ТаблицаДокумента.ОтработаноДней,
	|	ТаблицаДокумента.Размер,
	|	ТаблицаДокумента.Результат,
	|	ТаблицаДокумента.СчетУчетаЗатрат,
	|	ТаблицаДокумента.СтатьяЗатрат
	|ПОМЕСТИТЬ ВременнаяТаблицаНачисления
	|ИЗ
	|	Документ.Отпуск.Начисления КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.КоличествоДней,
	|	ТаблицаДокумента.КоличествоДнейФакт,
	|	ТаблицаДокумента.ВидОтпуска
	|ПОМЕСТИТЬ ВременнаяТаблицаДополнительныеОтпуска
	|ИЗ
	|	Документ.Отпуск.ДополнительныеОтпуска КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Результат", ДокументСсылка.Начисления.Итог("Результат"));
	Запрос.Выполнить();
	
	СформироватьТаблицаНачисления(ДокументСсылка, СтруктураДополнительныеСвойства);
	//СформироватьТаблицаОстаткиДнейОтпуска(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаВзаиморасчетыССотрудниками(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаИспользованиеДнейОтпуска(ДокументСсылка, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

#Область ИнтерфейсПечати

// Формирует запрос по документу.
//
Функция СформироватьЗапросДляПечати(МассивОбъектов) Экспорт
	
	Запрос = Новый Запрос;	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Отпуск.Дата КАК ДатаДокумента,
	|	Отпуск.Номер КАК НомерДокумента,
	|	Отпуск.ФизЛицо КАК Сотрудник,
	|	Отпуск.Подразделение,
	|	Отпуск.Должность,
	|	Отпуск.ДатаНачала,
	|	Отпуск.ДатаОкончания,
	|	Отпуск.ФизЛицо.Код КАК ТабельныйНомер,
	|	Отпуск.Организация.КодПоОКПО КАК КодПоОКПО,
	|	Отпуск.Организация.НаименованиеПолное КАК ПредставлениеОрганизации,
	|	Отпуск.Организация,
	|	Отпуск.Ссылка,
	|	Отпуск.ДатаНачалаРабочегоГода,
	|	Отпуск.ДатаОкончанияРабочегоГода,
	|	Отпуск.МетодРасчета,
	|	Отпуск.Дней,
	|	Отпуск.ДнейДополнительногоОтпуска,
	|	Отпуск.СуммаСреднийЗаработок,
	|	Отпуск.ДополнительныеОтпуска.(
	|		ВидОтпуска КАК ВидОтпуска,
	|		КоличествоДнейФакт
	|	),
	|	Отпуск.СреднийЗаработок.(
	|		ПериодРегистрации,
	|		НормаДней,
	|		НормаЧасов,
	|		ОтработаноДней,
	|		Результат КАК СуммаСЗ
	|	),
	|	Отпуск.Начисления.(
	|		ПериодРегистрации,
	|		ДатаНачала,
	|		ДатаОкончания,
	|		ОтработаноДней,
	|		Результат КАК СуммаНачислено
	|	),
	|	Отпуск.СредняяПремия.(
	|		Результат
	|	)
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
	Перем Ошибки;
	
	Выборка = СформироватьЗапросДляПечати(МассивОбъектов).Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ПервыйДокумент = Истина;	
	
	Пока Выборка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Отпуск_ПриказНаОтпуск";     
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Отпуск.ПФ_MXL_ПриказНаОтпуск");		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");							
		ОбластьМакета.Параметры.Заполнить(Выборка);	
		ОбластьМакета.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Выборка.НомерДокумента);	
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		Если Выборка.МетодРасчета <> Справочники.МетодыРасчетаОтпуска.БезСодержания 
			И Выборка.МетодРасчета <> Справочники.МетодыРасчетаОтпуска.БезСодержанияДолгосрочный
			И Выборка.МетодРасчета <> Справочники.МетодыРасчетаОтпуска.БезСодержанияКраткосрочный
			И Выборка.МетодРасчета <> Справочники.МетодыРасчетаОтпуска.БезСодержанияПоУходуЗаРебенком Тогда
			ОбластьМакета 			= Макет.ПолучитьОбласть("ДопОтпуск");
			ОбластьМакетаРасшифрока = Макет.ПолучитьОбласть("ДопОтпускРасшифровка");
			
			ОбластьМакета.Параметры.Дней						= Выборка.Дней - Выборка.ДнейДополнительногоОтпуска;
			ОбластьМакета.Параметры.ДатаНачалаРабочегоГода		= Формат(Выборка.ДатаНачалаРабочегоГода,"ДЛФ=D");
			ОбластьМакета.Параметры.ДатаОкончанияРабочегоГода	= Формат(Выборка.ДатаОкончанияРабочегоГода,"ДЛФ=D");
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
				
			//ВыборкаДополнительныеОтпуска = Выборка.ДополнительныеОтпуска.Выбрать();
			//Пока ВыборкаДополнительныеОтпуска.Следующий() Цикл
			//	Если Не ВыборкаДополнительныеОтпуска.ВидОтпуска = Справочники.ДополнительныеОтпуска.Основной Тогда 
			//		ОбластьМакетаРасшифрока.Параметры.Заполнить(ВыборкаДополнительныеОтпуска);
			//		ТабличныйДокумент.Вывести(ОбластьМакетаРасшифрока);
			//	КонецЕсли;
			//КонецЦикла;
			
		КонецЕсли;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ОбластьМакета.Параметры.ДатаНачала					= Формат(Выборка.ДатаНачала,"ДЛФ=D");
		ОбластьМакета.Параметры.ДатаОкончания				= Формат(Выборка.ДатаОкончания,"ДЛФ=D");
		ОбластьМакета.Параметры.ВсегоДней					= Выборка.Дней;
		ОбластьМакета.Параметры.ПредставлениеОрганизации    = Выборка.ПредставлениеОрганизации;
		
		Структура = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Выборка.Организация, Выборка.ДатаДокумента);
		Если НЕ Структура.Свойство("Руководитель") = Неопределено Тогда
			ОбластьМакета.Параметры.ДолжностьРуководителя 	= Структура.РуководительДолжность;
			ОбластьМакета.Параметры.ФИОРуководителя 		= Структура.Руководитель;		
		КонецЕсли;		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
	КонецЦикла;
	
	Если НЕ Ошибки = Неопределено Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	КонецЕсли;	
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	// Добавление дополнительных параметров
	БухгалтерскиеОтчетыКлиентСервер.ЗаполнитьДополнительныеПараметрыПечати(ТабличныйДокумент);
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

Функция ПечатьЗапискиРасчетОПредоставленииОтпуска(МассивОбъектов, ОбъектыПечати)
	
	ВыборкаШапка = СформироватьЗапросДляПечати(МассивОбъектов).Выбрать();
		
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ПервыйДокумент = Истина;
	
	Пока ВыборкаШапка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Отпуск_ЗапискаРасчетОПредоставленииОтпуска";     
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Отпуск.ПФ_MXL_ЗапискаРасчетОПредоставленииОтпуска");		
		//Шапка
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(ВыборкаШапка);
		ОбластьМакета.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ВыборкаШапка.НомерДокумента);
		
		ОбластьМакета.Параметры.ДатаНачала					= Формат(ВыборкаШапка.ДатаНачала,"ДЛФ=D");
		ОбластьМакета.Параметры.ДатаОкончания				= Формат(ВыборкаШапка.ДатаОкончания,"ДЛФ=D");
		ОбластьМакета.Параметры.ДатаНачалаРабочегоГода		= Формат(ВыборкаШапка.ДатаНачала,"ДЛФ=D");
		ОбластьМакета.Параметры.ДатаОкончанияРабочегоГода	= Формат(ВыборкаШапка.ДатаОкончания,"ДЛФ=D");
		ТабличныйДокумент.Вывести(ОбластьМакета);

		//ДопОтпуска
		ОбластьМакета = Макет.ПолучитьОбласть("ДополнительныеОтпуска");
		//Выборка = ВыборкаШапка.ДополнительныеОтпуска.Выбрать();
		//Пока Выборка.Следующий() Цикл
		//	Если Не Выборка.ВидОтпуска = Справочники.ДополнительныеОтпуска.Основной Тогда 
		//		ОбластьМакета.Параметры.Заполнить(Выборка);
		//		ТабличныйДокумент.Вывести(ОбластьМакета);
		//	КонецЕсли;
		//КонецЦикла;
		
		//СреднийЗаработокШапка
		ОбластьМакета = Макет.ПолучитьОбласть("СреднийЗаработокШапка");
		ТабличныйДокумент.Вывести(ОбластьМакета);

		//СреднийЗаработок
		ОбластьМакета = Макет.ПолучитьОбласть("СреднийЗаработок");
		Выборка = ВыборкаШапка.СреднийЗаработок.Выбрать();	
		
		ИтогоНормаЧасовСЗ = 0; 
		ИтогоСуммаСЗ = 0;
		Пока Выборка.Следующий() Цикл
			ОбластьМакета.Параметры.Заполнить(Выборка);
			ОбластьМакета.Параметры.ГодПериодРегистрации = Год(Выборка.ПериодРегистрации);
			ОбластьМакета.Параметры.МесяцПериодРегистрации = Месяц(Выборка.ПериодРегистрации);
			ИтогоНормаЧасовСЗ 	= ИтогоНормаЧасовСЗ + Выборка.НормаЧасов;
			ИтогоСуммаСЗ		= ИтогоСуммаСЗ + Выборка.СуммаСЗ;
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		//НачисленияШапка
		ОбластьМакета = Макет.ПолучитьОбласть("НачисленияШапка");
		ОбластьМакета.Параметры.Заполнить(ВыборкаШапка);
		
		//Премия
		ТЗПремии = ВыборкаШапка.СредняяПремия.Выгрузить();
		СуммаПремии = ТЗПремии.Итог("Результат");
		
		ОбластьМакета.Параметры.СуммаПремии = СуммаПремии;
		ОбластьМакета.Параметры.ИтогоСуммаСЗ = ИтогоСуммаСЗ + СуммаПремии;
		ОбластьМакета.Параметры.КоличествоЧасовРП = ИтогоНормаЧасовСЗ;										
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		//Начисления
		ОбластьМакета = Макет.ПолучитьОбласть("Начисления");
		Выборка = ВыборкаШапка.Начисления.Выбрать();
		ИтогоСуммаНачислено = 0;
		Пока Выборка.Следующий() Цикл
			ОбластьМакета.Параметры.Заполнить(Выборка);
			ИтогоСуммаНачислено	= ИтогоСуммаНачислено + Выборка.СуммаНачислено;
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;

		//Подвал
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ВалютаРегламентированногоУчета 	= ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		ОбластьМакета.Параметры.ИтогоСуммаНачисленоПрописью	= РаботаСКурсамиВалют.СформироватьСуммуПрописью(ИтогоСуммаНачислено, ВалютаРегламентированногоУчета);
		ОбластьМакета.Параметры.ИтогоСуммаНачислено	= ИтогоСуммаНачислено;
		Структура = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(ВыборкаШапка.Организация, ВыборкаШапка.ДатаДокумента);
		Если НЕ Структура.Свойство("ГлавныйБухгалтер") 	= Неопределено Тогда
			ОбластьМакета.Параметры.ФИОГлавБуха 		= Структура.ГлавныйБухгалтер;		
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаШапка.Ссылка);
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	// Добавление дополнительных параметров
	БухгалтерскиеОтчетыКлиентСервер.ЗаполнитьДополнительныеПараметрыПечати(ТабличныйДокумент);
	
	Возврат ТабличныйДокумент;
	
КонецФункции //ПечатьЗапискиРасчетОПредоставленииОтпуска()


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
		"Приказ на отпуск", 
		ПечатьПриказаНаОтпуск(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗапискаРасчетОПредоставленииОтпуска") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"ЗапискаРасчетОПредоставленииОтпуска", 
		"Записка расчёт о предоставлении отпуска", 
		ПечатьЗапискиРасчетОПредоставленииОтпуска(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

//Команды печати
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПриказНаОтпуск";
	КомандаПечати.Представление = НСтр("ru = 'Приказ на отпуск'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ЗапискаРасчетОПредоставленииОтпуска";
	КомандаПечати.Представление = НСтр("ru = 'Записка расчёт о предоставлении отпуска'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 2;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
