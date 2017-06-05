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
		|	ТаблицаДокумента.ПериодРегистрации,
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.ФизЛицо,
		|	ТаблицаДокумента.ВидРасчета,
		|	ТаблицаДокумента.ДатаНачала КАК ПериодДействияНачало,
		|	КОНЕЦПЕРИОДА(ТаблицаДокумента.ДатаОкончания, ДЕНЬ) КАК ПериодДействияКонец,
		|	ТаблицаДокумента.Дней КАК ОтработаноДней,
		|	ТаблицаДокумента.ГрафикРаботы КАК ГрафикРаботы
		|ИЗ
		|	ВременнаяТаблицаНачисления КАК ТаблицаДокумента";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаНачисления", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаПлановыеНачисленияИУдержания()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка.ПериодРегистрации КАК ПериодРегистрации,
		|	ТаблицаДокумента.Ссылка.Организация КАК Организация,
		|	ТаблицаДокумента.ФизЛицо,
		|	ТаблицаДокумента.ВидОтсутствия КАК ВидРасчета,
		|	ТаблицаДокумента.ДатаНачала,
		|	ТаблицаДокумента.ДатаОкончания,
		|	ТаблицаДокумента.Дней,
		|	ТаблицаДокумента.ГрафикРаботы
		|ПОМЕСТИТЬ ВременнаяТаблицаНачисления
		|ИЗ
		|	Документ.Неявка.Сотрудники КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТаблицаНачисления(ДокументСсылка, СтруктураДополнительныеСвойства);
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

#КонецЕсли
