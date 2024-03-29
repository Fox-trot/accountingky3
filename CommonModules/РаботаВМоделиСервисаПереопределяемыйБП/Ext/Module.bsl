﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// См. РаботаВМоделиСервисаПереопределяемый.УстановитьПраваПоУмолчанию.
Процедура УстановитьПраваПоУмолчанию(Пользователь) Экспорт
	
	// БПКР
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ГруппыДоступаПользователи.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|ГДЕ
		|	ГруппыДоступаПользователи.Пользователь = &Пользователь
		|	И НЕ ГруппыДоступаПользователи.Ссылка В (&НовыеГруппы)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ГруппыДоступа.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ГруппыДоступа КАК ГруппыДоступа
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|		ПО ГруппыДоступа.Ссылка = ГруппыДоступаПользователи.Ссылка
		|			И (ГруппыДоступаПользователи.Пользователь = &Пользователь)
		|ГДЕ
		|	ГруппыДоступа.Ссылка В(&НовыеГруппы)
		|	И ГруппыДоступаПользователи.Ссылка ЕСТЬ NULL";
	
	НовыеГруппыДоступа = Новый Массив;
	НовыеГруппыДоступа.Добавить(Справочники.ГруппыДоступа.НайтиПоНаименованию("Пользователи"));
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("НовыеГруппы", НовыеГруппыДоступа);
	
	НачатьТранзакцию();
	Попытка
		Результаты = Запрос.ВыполнитьПакет();
		
		ВыборкаИсключить = Результаты[0].Выбрать();
		Пока ВыборкаИсключить.Следующий() Цикл
			ГруппаОбъект = ВыборкаИсключить.Ссылка.ПолучитьОбъект();
			ГруппаОбъект.Пользователи.Удалить(ГруппаОбъект.Пользователи.Найти(Пользователь, "Пользователь"));
			ГруппаОбъект.Записать();
		КонецЦикла;
		
		ВыборкаДобавить = Результаты[1].Выбрать();
		Пока ВыборкаДобавить.Следующий() Цикл
			ГруппаОбъект = ВыборкаДобавить.Ссылка.ПолучитьОбъект();
			СтрокаПользователь = ГруппаОбъект.Пользователи.Добавить();
			СтрокаПользователь.Пользователь = Пользователь;
			ГруппаОбъект.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	// Конец БПКР
	
КонецПроцедуры

#КонецОбласти
