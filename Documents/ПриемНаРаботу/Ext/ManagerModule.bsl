﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список текущих дел пользователя.
//
// Параметры:
//  ТекущиеДела - ТаблицаЗначений - таблица значений с колонками:
//    * Идентификатор - Строка - внутренний идентификатор дела, используемый механизмом "Текущие дела".
//    * ЕстьДела      - Булево - если Истина, дело выводится в списке текущих дел пользователя.
//    * Важное        - Булево - если Истина, дело будет выделено красным цветом.
//    * Представление - Строка - представление дела, выводимое пользователю.
//    * Количество    - Число  - количественный показатель дела, выводится в строке заголовка дела.
//    * Форма         - Строка - полный путь к форме, которую необходимо открыть при нажатии на гиперссылку
//                               дела на панели "Текущие дела".
//    * ПараметрыФормы- Структура - параметры, с которыми нужно открывать форму показателя.
//    * Владелец      - Строка, объект метаданных - строковый идентификатор дела, которое будет владельцем для текущего
//                      или объект метаданных подсистема.
//    * Подсказка     - Строка - текст подсказки.
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	Если Не ПравоДоступа("Редактирование", Метаданные.Документы.НачислениеЗарплаты) Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоНеПроведенныхДокументов = КоличествоНеПроведенныхДокументов();
	
	ИдентификаторДела = "НачислениеЗарплаты";
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = ИдентификаторДела;
	Дело.ЕстьДела       = КоличествоНеПроведенныхДокументов.Всего > 0;
	Дело.Представление  = НСтр("ru = 'Начисления заработной платы'");
	Дело.Количество     = КоличествоНеПроведенныхДокументов.Всего;
	Дело.Форма          = "Документ.НачислениеЗарплаты.ФормаСписка";
	Дело.ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Проведен", Ложь));
	Дело.Владелец       = Метаданные.Подсистемы.Зарплата;
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "НачислениеЗарплатыПомеченыНаУдаление";
	Дело.ЕстьДела       = КоличествоНеПроведенныхДокументов.Записаны > 0;
	Дело.Важное         = Истина;
	Дело.Представление  = НСтр("ru = 'Не проведено'");
	Дело.Количество     = КоличествоНеПроведенныхДокументов.Записаны;
	Дело.Владелец       = ИдентификаторДела;
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ЗаказыПокупателяСогласовано";
	Дело.ЕстьДела       = КоличествоНеПроведенныхДокументов.ПомеченыНаУдаление > 0;
	Дело.Представление  = НСтр("ru = 'Помеченные на удаление'");
	Дело.Количество     = КоличествоНеПроведенныхДокументов.ПомеченыНаУдаление;
	Дело.Владелец       = ИдентификаторДела;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаСотрудники(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Период,
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.ФизЛицо,
		|	ТаблицаДокумента.Подразделение,
		|	ТаблицаДокумента.Должность,
		|	ТаблицаДокумента.ЗанимаемыхСтавок,
		|	ТаблицаДокумента.ИспытательныйСрок,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Прием) КАК ВидСобытия,
		|	ТаблицаДокумента.ГрафикРаботы
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ТаблицаДокумента
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ДатаОкончанияРаботы,
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.ФизЛицо,
		|	ТаблицаДокумента.Подразделение,
		|	ТаблицаДокумента.Должность,
		|	ТаблицаДокумента.ЗанимаемыхСтавок,
		|	ТаблицаДокумента.ИспытательныйСрок,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение),
		|	ТаблицаДокумента.ГрафикРаботы 
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ТаблицаДокумента
		|ГДЕ
		|	НЕ ТаблицаДокумента.ДатаОкончанияРаботы = ДАТАВРЕМЯ(1, 1, 1)";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСотрудники", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаСотрудники()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаПлановыеНачисленияНачало(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	// 1. Таблица по основному виду начисления
	// 2. Таблица по дополнительным видам начисления
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	1 КАК Порядок,
		|	ВременнаяТаблицаШапка.Период,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.ФизЛицо,
		|	ВременнаяТаблицаШапка.ВидРасчета,
		|	ВременнаяТаблицаШапка.Размер,
		|	ИСТИНА КАК Основной,
		|	ВременнаяТаблицаШапка.Подразделение,
		|	ВременнаяТаблицаШапка.Должность,
		|	ВременнаяТаблицаШапка.ГрафикРаботы
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	2,
		|	ВременнаяТаблицаШапка.Период,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.ФизЛицо,
		|	ВременнаяТаблицаНачисления.ВидРасчета,
		|	ВременнаяТаблицаНачисления.Размер,
		|	ЛОЖЬ,
		|	ВременнаяТаблицаШапка.Подразделение,
		|	ВременнаяТаблицаШапка.Должность,
		|	ВременнаяТаблицаШапка.ГрафикРаботы
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаНачисления КАК ВременнаяТаблицаНачисления
		|		ПО (ИСТИНА)";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПлановыеНачисленияНачало", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаПлановыеНачисленияНачало()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаПлановыеНачисленияОкончание(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	// 1. Таблица по основному виду начисления
	// 2. Таблица по дополнительным видам начисления
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	1 КАК Порядок,
		|	ВременнаяТаблицаШапка.ДатаОкончанияРаботы КАК Период,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.ФизЛицо,
		|	ВременнаяТаблицаШапка.ВидРасчета,
		|	ВременнаяТаблицаШапка.Ссылка КАК ДокументСсылка,
		|	ВременнаяТаблицаШапка.Размер
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|ГДЕ
		|	НЕ ВременнаяТаблицаШапка.ДатаОкончанияРаботы = ДАТАВРЕМЯ(1, 1, 1)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	2,
		|	ВременнаяТаблицаШапка.ДатаОкончанияРаботы,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.ФизЛицо,
		|	ВременнаяТаблицаНачисления.ВидРасчета,
		|	ВременнаяТаблицаШапка.Ссылка,
		|	ВременнаяТаблицаНачисления.Размер
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаНачисления КАК ВременнаяТаблицаНачисления
		|		ПО (ИСТИНА)
		|ГДЕ
		|	НЕ ВременнаяТаблицаШапка.ДатаОкончанияРаботы = ДАТАВРЕМЯ(1, 1, 1)";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПлановыеНачисленияОкончание", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаПлановыеНачисленияОкончание()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаПлановыеУдержанияНачало(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Период,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.ФизЛицо,
		|	ВременнаяТаблицаУдержания.ВидРасчета,
		|	ВременнаяТаблицаУдержания.Размер
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаУдержания КАК ВременнаяТаблицаУдержания
		|		ПО (ИСТИНА)";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПлановыеУдержанияНачало", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаПлановыеУдержанияНачало()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаПлановыеУдержанияОкончание(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.ДатаОкончанияРаботы КАК Период,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.ФизЛицо,
		|	ВременнаяТаблицаУдержания.ВидРасчета,
		|	ВременнаяТаблицаШапка.Ссылка КАК ДокументСсылка,
		|	ВременнаяТаблицаУдержания.Размер
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаУдержания КАК ВременнаяТаблицаУдержания
		|		ПО (ИСТИНА)
		|ГДЕ
		|	НЕ ВременнаяТаблицаШапка.ДатаОкончанияРаботы = ДАТАВРЕМЯ(1, 1, 1)";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПлановыеУдержанияОкончание", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаПлановыеУдержанияОкончание()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаСтатусыСотрудников(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Период,
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.ФизЛицо,
		|	ТаблицаДокумента.Статус,
		|	ТаблицаДокумента.ДопВычет
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ТаблицаДокумента";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСтатусыСотрудников", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаСтатусыСотрудников()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаСтажиСотрудников(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.ФизЛицо КАК ФизЛицо,
		|	ТаблицаДокумента.ОбщийСтажЛет КАК КоличествоЛет,
		|	ТаблицаДокумента.ОбщийСтажМесяцев КАК КоличествоМесяцев,
		|	ТаблицаДокумента.ОбщийСтажДней КАК КоличествоДней
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ТаблицаДокумента";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСтажиСотрудников", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаСтажиСотрудников()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка КАК Ссылка,
		|	ТаблицаДокумента.Период КАК Период,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.ФизЛицо КАК ФизЛицо,
		|	ТаблицаДокумента.Подразделение КАК Подразделение,
		|	ТаблицаДокумента.Должность КАК Должность,
		|	ТаблицаДокумента.ВидРасчета КАК ВидРасчета,
		|	ТаблицаДокумента.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
		|	ТаблицаДокумента.ГрафикРаботы КАК ГрафикРаботы,
		|	ТаблицаДокумента.Статус КАК Статус,
		|	ТаблицаДокумента.Размер КАК Размер,
		|	ТаблицаДокумента.ИспытательныйСрок КАК ИспытательныйСрок,
		|	ТаблицаДокумента.ДопВычет КАК ДопВычет,
		|	ТаблицаДокумента.ДатаОкончанияРаботы КАК ДатаОкончанияРаботы,
		|	ТаблицаДокумента.ОбщийСтажЛет КАК ОбщийСтажЛет,
		|	ТаблицаДокумента.ОбщийСтажМесяцев КАК ОбщийСтажМесяцев,
		|	ТаблицаДокумента.ОбщийСтажДней КАК ОбщийСтажДней
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ПриемНаРаботу КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ВидРасчета КАК ВидРасчета,
		|	ТаблицаДокумента.Размер КАК Размер
		|ПОМЕСТИТЬ ВременнаяТаблицаНачисления
		|ИЗ
		|	Документ.ПриемНаРаботу.Начисления КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПриемНаРаботуУдержания.ВидРасчета КАК ВидРасчета,
		|	ПриемНаРаботуУдержания.Размер КАК Размер
		|ПОМЕСТИТЬ ВременнаяТаблицаУдержания
		|ИЗ
		|	Документ.ПриемНаРаботу.Удержания КАК ПриемНаРаботуУдержания
		|ГДЕ
		|	ПриемНаРаботуУдержания.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТаблицаСотрудники(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаПлановыеНачисленияНачало(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаПлановыеНачисленияОкончание(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаПлановыеУдержанияНачало(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаПлановыеУдержанияОкончание(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаСтатусыСотрудников(ДокументСсылка,СтруктураДополнительныеСвойства);
	СформироватьТаблицаСтажиСотрудников(ДокументСсылка,СтруктураДополнительныеСвойства);

КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КоличествоНеПроведенныхДокументов()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КОЛИЧЕСТВО(НачислениеЗарплаты.Ссылка) КАК Количество
		|ИЗ
		|	Документ.НачислениеЗарплаты КАК НачислениеЗарплаты
		|ГДЕ
		|	НЕ НачислениеЗарплаты.Проведен
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(НачислениеЗарплаты.Ссылка)
		|ИЗ
		|	Документ.НачислениеЗарплаты КАК НачислениеЗарплаты
		|ГДЕ
		|	НачислениеЗарплаты.ПометкаУдаления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(НачислениеЗарплаты.Ссылка)
		|ИЗ
		|	Документ.НачислениеЗарплаты КАК НачислениеЗарплаты
		|ГДЕ
		|	НЕ НачислениеЗарплаты.Проведен
		|	И НЕ НачислениеЗарплаты.ПометкаУдаления";
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Результат = Новый Структура("Всего, ПомеченыНаУдаление, Записаны");
	Результат.Всего = РезультатЗапроса[0].Количество;
	Результат.ПомеченыНаУдаление = РезультатЗапроса[1].Количество;
	Результат.Записаны = РезультатЗапроса[2].Количество;
	
	Возврат Результат;
	
КонецФункции

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
Функция СформироватьЗапросДляПечати(ТекущийДокумент, ИмяМакета)
	
	Запрос = Новый Запрос;	
	
	Если ИмяМакета = "ПриказОПриеме" Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПриемНаРаботу.Дата КАК ДатаДокумента,
		|	ПриемНаРаботу.Номер КАК НомерДокумента,
		|	ПриемНаРаботу.Организация.НаименованиеПолное КАК ПредставлениеОрганизации,
		|	ПриемНаРаботу.Организация.КодПоОКПО КАК КодПоОКПО,
		|	ПриемНаРаботу.Организация,
		|	ПриемНаРаботу.ФизЛицо КАК Сотрудник,
		|	ПриемНаРаботу.Подразделение,
		|	ПриемНаРаботу.Должность.Наименование КАК Должность,
		|	ПриемНаРаботу.ИспытательныйСрок,
		|	ПриемНаРаботу.Комментарий КАК Основание,
		|	ПриемНаРаботу.Период КАК ДатаПриема,
		|	ПриемНаРаботу.ФизЛицо.Код КАК ТабельныйНомер,
		|	ПриемНаРаботу.ФизЛицо.ИНН КАК ИНН,
		|	ПриемНаРаботу.Ссылка,
		|	ПриемНаРаботу.Размер,
		|	ПриемНаРаботу.ДатаОкончанияРаботы
		|ИЗ
		|	Документ.ПриемНаРаботу КАК ПриемНаРаботу
		|ГДЕ
		|	ПриемНаРаботу.Ссылка = &ТекущийДокумент";
		
	ИначеЕсли ИмяМакета = "ТрудовойДоговор"	Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФизическиеЛицаКонтактнаяИнформация.Представление,
		|	ФизическиеЛицаКонтактнаяИнформация.Ссылка
		|ПОМЕСТИТЬ АдресСотрудника
		|ИЗ
		|	Справочник.ФизическиеЛица.КонтактнаяИнформация КАК ФизическиеЛицаКонтактнаяИнформация
		|ГДЕ
		|	ФизическиеЛицаКонтактнаяИнформация.Ссылка = &Физлицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПриемНаРаботу.Дата КАК ДатаДокумента,
		|	ПриемНаРаботу.Номер КАК НомерДокумента,
		|	ПриемНаРаботу.Организация.НаименованиеПолное КАК ПредставлениеОрганизации,
		|	ПриемНаРаботу.Организация,
		|	ПриемНаРаботу.Подразделение,
		|	ПриемНаРаботу.Должность КАК Должность,
		|	ПриемНаРаботу.ИспытательныйСрок,
		|	ПриемНаРаботу.Комментарий КАК Основание,
		|	ПриемНаРаботу.Период КАК ДатаПриема,
		|	ПриемНаРаботу.ФизЛицо.ДатаРождения КАК ДатаРождения,
		|	ДокументыФизическихЛицСрезПоследних.ДатаВыдачи,
		|	ДокументыФизическихЛицСрезПоследних.КемВыдан,
		|	ДокументыФизическихЛицСрезПоследних.Серия,
		|	ДокументыФизическихЛицСрезПоследних.ВидДокумента,
		|	ДокументыФизическихЛицСрезПоследних.Номер КАК Номер,
		|	АдресСотрудника.Представление КАК АдресСотрудника,
		|	ПриемНаРаботу.ДатаОкончанияРаботы,
		|	ПриемНаРаботу.Размер,
		|	ПриемНаРаботу.ФизЛицо.Наименование КАК Сотрудник
		|ИЗ
		|	Документ.ПриемНаРаботу КАК ПриемНаРаботу
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц.СрезПоследних(&Дата, Физлицо = &Физлицо) КАК ДокументыФизическихЛицСрезПоследних
		|		ПО ПриемНаРаботу.ФизЛицо = ДокументыФизическихЛицСрезПоследних.Физлицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ АдресСотрудника КАК АдресСотрудника
		|		ПО ПриемНаРаботу.ФизЛицо = АдресСотрудника.Ссылка
		|ГДЕ
		|	ПриемНаРаботу.Ссылка = &ТекущийДокумент";
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Дата", ТекущийДокумент.Дата);
	Запрос.УстановитьПараметр("Физлицо", ТекущийДокумент.Физлицо);
	Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент);
	
	Возврат Запрос.Выполнить();
	
КонецФункции

// Сформировать печатные формы объектов
//
Функция ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, ИмяМакета)
	Перем Ошибки;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;     

	ПервыйДокумент = Истина;
	
	Для каждого  ТекущийДокумент Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Если ИмяМакета = "ПриказОПриеме" Тогда
			ТабличныйДокумент.КлючПараметровПечати = "ПриемНаРаботу_ПриказОПриеме";     
			
			Выборка = СформироватьЗапросДляПечати(ТекущийДокумент, ИмяМакета).Выбрать();
			Выборка.Следующий();
			
			Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПриемНаРаботу.ПФ_MXL_ПриказОПриеме");
			ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
			ОбластьМакета.Параметры.Заполнить(Выборка);
			ОбластьМакета.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Выборка.НомерДокумента);
			
			Если ЗначениеЗаполнено(Выборка.ИспытательныйСрок) Тогда 
				КолвоМесяцев = Год(Выборка.ИспытательныйСрок)*12 + Месяц(Выборка.ИспытательныйСрок) - Год(Выборка.ДатаПриема)*12 - Месяц(Выборка.ДатаПриема);		
				ОбластьМакета.Параметры.ИспытательныйСрок = НРег(ЧислоПрописью(КолвоМесяцев,"","месяц, месяца, месяцев, м, день, дня, дней, м, 0")); 
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Выборка.ДатаОкончанияРаботы) Тогда 
				ОбластьМакета.Параметры.ДатаОкончанияРаботы = Выборка.ДатаОкончанияРаботы; 	
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Выборка.ДатаОкончанияРаботы)  Тогда
			     ОбластьМакета.Параметры.Условия = "Временное";
			Иначе 
				 ОбластьМакета.Параметры.Условия = "Постоянное";
			КонецЕсли;
			 
			Структура = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Выборка.Организация, Выборка.ДатаДокумента);
			Если НЕ Структура.Свойство("Руководитель") = Неопределено Тогда
				ОбластьМакета.Параметры.ДолжностьРуководителя 	= Структура.РуководительДолжность;
				ОбластьМакета.Параметры.ФИОРуководителя 		= Структура.Руководитель;		
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		ИначеЕсли ИмяМакета = "ТрудовойДоговор" Тогда  
			ТабличныйДокумент.КлючПараметровПечати = "ПриемНаРаботу_ТрудовойДоговор";     
			
			Выборка = СформироватьЗапросДляПечати(ТекущийДокумент,ИмяМакета).Выбрать();
			Выборка.Следующий();
			
			Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПриемНаРаботу.ПФ_MXL_ТрудовойДоговор");
			ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
			ОбластьМакета.Параметры.Заполнить(Выборка);
			ОбластьМакета.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Выборка.НомерДокумента);
			
			ОбластьМакета.Параметры.ДатаРождения = Формат(Выборка.ДатаРождения, "ДЛФ=DD");
			ОбластьМакета.Параметры.СтрокаДокумент = "" + Выборка.ВидДокумента + " " + Выборка.Серия + " №" + Выборка.Номер + " выдан " + Выборка.КемВыдан + " " + Формат(Выборка.ДатаВыдачи, "ДЛФ=DD");
			
			Если ЗначениеЗаполнено(Выборка.ИспытательныйСрок) Тогда 
				КолвоМесяцев = Год(Выборка.ИспытательныйСрок)*12 + Месяц(Выборка.ИспытательныйСрок) - Год(Выборка.ДатаПриема)*12 - Месяц(Выборка.ДатаПриема);		
				ОбластьМакета.Параметры.ИспытательныйСрок = НРег(ЧислоПрописью(КолвоМесяцев,"","месяц, месяца, месяцев, м, день, дня, дней, м, 0")); 
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Выборка.ДатаОкончанияРаботы) Тогда 
				ОбластьМакета.Параметры.СрокОпределенныйНеопределенный = НСтр("ru = '- на неопределенный срок;'");
			Иначе 
				ОбластьМакета.Параметры.СрокОпределенныйНеопределенный = НСтр("ru = '- на определенный срок;'");
			КонецЕсли;
			
			Структура = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Выборка.Организация, Выборка.ДатаДокумента);
			Если НЕ Структура.Свойство("Руководитель") = Неопределено Тогда
				ОбластьМакета.Параметры.ДолжностьРуководителя 	= Структура.РуководительДолжность;
				ОбластьМакета.Параметры.ФИОРуководителя 		= Структура.Руководитель;		
			КонецЕсли;

			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
	
	Если НЕ Ошибки = Неопределено Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	КонецЕсли;	
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	// Добавление дополнительных параметров
	БухгалтерскиеОтчетыКлиентСервер.ЗаполнитьДополнительныеПараметрыПечати(ТабличныйДокумент);
	
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриказОПриеме") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"ПриказОПриеме", 
		НСтр("ru = 'Приказ о приеме на работу'"), 
		ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "ПриказОПриеме"));
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТрудовойДоговор") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"ТрудовойДоговор", 
		НСтр("ru = 'Трудовой договор'"), 
		ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "ТрудовойДоговор"));
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПриказОПриеме";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о приеме на работу'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ТрудовойДоговор";
	КомандаПечати.Представление = НСтр("ru = 'Трудовой договор'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 2;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли