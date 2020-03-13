﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив Из Строка -
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("ТипПользователей");
	НеРедактируемыеРеквизиты.Добавить("Пользователь");
	НеРедактируемыеРеквизиты.Добавить("ОсновнаяГруппаДоступаПоставляемогоПрофиля");
	НеРедактируемыеРеквизиты.Добавить("ВидыДоступа.*");
	НеРедактируемыеРеквизиты.Добавить("ЗначенияДоступа.*");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЭтоГруппа
	|	ИЛИ Профиль <> Значение(Справочник.ПрофилиГруппДоступа.Администратор)
	|	  И ЭтоАвторизованныйПользователь(Ответственный)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриРегистрацииОбработчиковВыгрузкиДанных.
Процедура ПередВыгрузкойОбъекта(Контейнер, МенеджерВыгрузкиОбъекта, Сериализатор, Объект, Артефакты, Отказ) Экспорт
	
	УправлениеДоступомСлужебный.ПередВыгрузкойОбъекта(Контейнер, МенеджерВыгрузкиОбъекта, Сериализатор, Объект, Артефакты, Отказ);
	
КонецПроцедуры

// Конец ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Наименование");
	Поля.Добавить("Пользователь");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Данные.Пользователь) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Представление = УправлениеДоступомСлужебныйКлиентСервер.ПредставлениеГруппыДоступа(Данные);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Устанавливает пометку удаления группам доступа, если установлена
// пометка удаления у профиля группы доступа. Требуется, например,
// при удалении предопределенных профилей групп доступа,
// т.к. платформа не вызывает обработчики объектов при
// установке пометки удаления бывшим предопределенным
// элементам в процессе обновления конфигурации базы данных.
//
// Параметры:
//  ЕстьИзменения - Булево - (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ПометитьНаУдалениеГруппыДоступаПомеченныхПрофилей(ЕстьИзменения = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДоступа.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|ГДЕ
	|	ГруппыДоступа.Профиль <> ЗНАЧЕНИЕ(Справочник.ПрофилиГруппДоступа.Администратор)
	|	И ГруппыДоступа.Профиль.ПометкаУдаления
	|	И НЕ ГруппыДоступа.ПометкаУдаления
	|	И НЕ ГруппыДоступа.Предопределенный";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ГруппаДоступаОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ГруппаДоступаОбъект.ПометкаУдаления = Истина;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ГруппаДоступаОбъект);
		РегистрыСведений.ТаблицыГруппДоступа.ОбновитьДанныеРегистра(Выборка.Ссылка);
		РегистрыСведений.ЗначенияГруппДоступа.ОбновитьДанныеРегистра(Выборка.Ссылка);
		ПользователиДляОбновления = ПользователиДляОбновленияРолей(Неопределено, ГруппаДоступаОбъект);
		УправлениеДоступом.ОбновитьРолиПользователей(ПользователиДляОбновления);
		ЕстьИзменения = Истина;
	КонецЦикла;
	
КонецПроцедуры

// Выполняет обновление видов доступа групп доступа указанного профиля.
//  При этом возможно не удалять виды доступа из группы доступа,
// которые удалены в профиле этой группы доступа, в случае
// когда в группе доступа назначены значения доступа по
// удаляемому виду доступа.
// 
// Параметры:
//  Профиль - СправочникСсылка.ПрофилиГруппДоступа - профиль групп доступа.
//
//  ОбновлятьГруппыДоступаСУстаревшимиНастройками - Булево - обновлять группы доступа.
//
// Возвращаемое значение:
//  Булево - когда Истина, группа доступа была изменена,
//           когда Ложь никаких изменений не было выполнено.
//
Функция ОбновитьГруппыДоступаПрофиля(Профиль, ОбновлятьГруппыДоступаСУстаревшимиНастройками = Ложь) Экспорт
	
	ГруппаДоступаОбновлена = Ложь;
	
	ВидыДоступаПрофиля = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Профиль, "ВидыДоступа").Выгрузить();
	Индекс = ВидыДоступаПрофиля.Количество() - 1;
	Пока Индекс >= 0 Цикл
		Строка = ВидыДоступаПрофиля[Индекс];
		СвойстваВидаДоступа = УправлениеДоступомСлужебный.СвойстваВидаДоступа(Строка.ВидДоступа);
		
		Если СвойстваВидаДоступа = Неопределено Тогда
			ВидыДоступаПрофиля.Удалить(Строка);
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДоступа.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|ГДЕ
	|	НЕ(ГруппыДоступа.Профиль <> &Профиль
	|				И НЕ(&Профиль = ЗНАЧЕНИЕ(Справочник.ПрофилиГруппДоступа.Администратор)
	|						И ГруппыДоступа.Ссылка = ЗНАЧЕНИЕ(Справочник.ГруппыДоступа.Администраторы)))";
	
	Запрос.УстановитьПараметр("Профиль", Профиль.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		// Проверка необходимости/возможности обновления группы доступа.
		ГруппаДоступа = Выборка.Ссылка.ПолучитьОбъект();
		
		Если ГруппаДоступа.Ссылка = Администраторы
		   И ГруппаДоступа.Профиль <> Справочники.ПрофилиГруппДоступа.Администратор Тогда
			// Установка профиля Администратор, если не задан.
			ГруппаДоступа.Профиль = Справочники.ПрофилиГруппДоступа.Администратор;
		КонецЕсли;
		
		// Проверка состава видов доступа.
		СоставВидовДоступаИзменен = Ложь;
		ЕстьУдаляемыеВидыДоступаСЗаданнымиЗначениямиДоступа = Ложь;
		Если ГруппаДоступа.ВидыДоступа.Количество() <> ВидыДоступаПрофиля.НайтиСтроки(Новый Структура("Предустановленный", Ложь)).Количество() Тогда
			СоставВидовДоступаИзменен = Истина;
		Иначе
			Для каждого СтрокаВидаДоступа Из ГруппаДоступа.ВидыДоступа Цикл
				Если ВидыДоступаПрофиля.НайтиСтроки(Новый Структура("ВидДоступа, Предустановленный", СтрокаВидаДоступа.ВидДоступа, Ложь)).Количество() = 0 Тогда
					СоставВидовДоступаИзменен = Истина;
					Если ГруппаДоступа.ЗначенияДоступа.Найти(СтрокаВидаДоступа.ВидДоступа, "ВидДоступа") <> Неопределено Тогда
						ЕстьУдаляемыеВидыДоступаСЗаданнымиЗначениямиДоступа = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если СоставВидовДоступаИзменен
		   И ( ОбновлятьГруппыДоступаСУстаревшимиНастройками
		       ИЛИ НЕ ЕстьУдаляемыеВидыДоступаСЗаданнымиЗначениямиДоступа ) Тогда
			// Обновление группы доступа.
			// 1. Удаление лишних видов доступа и значений доступа (если есть).
			ТекущийНомерСтроки = ГруппаДоступа.ВидыДоступа.Количество()-1;
			Пока ТекущийНомерСтроки >= 0 Цикл
				ТекущийВидДоступа = ГруппаДоступа.ВидыДоступа[ТекущийНомерСтроки].ВидДоступа;
				Если ВидыДоступаПрофиля.НайтиСтроки(Новый Структура("ВидДоступа, Предустановленный", ТекущийВидДоступа, Ложь)).Количество() = 0 Тогда
					СтрокиЗначенийВидаДоступа = ГруппаДоступа.ЗначенияДоступа.НайтиСтроки(Новый Структура("ВидДоступа", ТекущийВидДоступа));
					Для каждого СтрокаЗначения Из СтрокиЗначенийВидаДоступа Цикл
						ГруппаДоступа.ЗначенияДоступа.Удалить(СтрокаЗначения);
					КонецЦикла;
					ГруппаДоступа.ВидыДоступа.Удалить(ТекущийНомерСтроки);
				КонецЕсли;
				ТекущийНомерСтроки = ТекущийНомерСтроки - 1;
			КонецЦикла;
			// 2. Добавление новых видов доступа (если есть).
			Для каждого СтрокаВидаДоступа Из ВидыДоступаПрофиля Цикл
				Если НЕ СтрокаВидаДоступа.Предустановленный 
				   И ГруппаДоступа.ВидыДоступа.Найти(СтрокаВидаДоступа.ВидДоступа, "ВидДоступа") = Неопределено Тогда
					
					НоваяСтрока = ГруппаДоступа.ВидыДоступа.Добавить();
					НоваяСтрока.ВидДоступа   = СтрокаВидаДоступа.ВидДоступа;
					НоваяСтрока.ВсеРазрешены = СтрокаВидаДоступа.ВсеРазрешены;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если ГруппаДоступа.Модифицированность() Тогда
			
			Если Не ОбновлениеИнформационнойБазы.ВыполняетсяОбновлениеИнформационнойБазы()
			   И Не ОбновлениеИнформационнойБазы.ЭтоВызовИзОбработчикаОбновления() Тогда
				
				ЗаблокироватьДанныеДляРедактирования(ГруппаДоступа.Ссылка, ГруппаДоступа.ВерсияДанных);
			КонецЕсли;
			
			ГруппаДоступа.ДополнительныеСвойства.Вставить("НеОбновлятьРолиПользователей");
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ГруппаДоступа);
			ГруппаДоступаОбновлена = Истина;
			
			Если Не ОбновлениеИнформационнойБазы.ВыполняетсяОбновлениеИнформационнойБазы()
			   И Не ОбновлениеИнформационнойБазы.ЭтоВызовИзОбработчикаОбновления() Тогда
				
				РазблокироватьДанныеДляРедактирования(ГруппаДоступа.Ссылка);
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат ГруппаДоступаОбновлена;
	
КонецФункции

// Возвращает ссылку на группу-родителя персональных групп доступа.
//  Если родитель не найден он будет создан.
//
// Параметры:
//  НеСоздавать  - Булево, если задан Истина, родитель не будет автоматически создан,
//                 а функция вернет Неопределено, если родитель не найден.
//
// Возвращаемое значение:
//  СправочникСсылка.ГруппыДоступа - ссылка на группу-родителя.
//
Функция РодительПерсональныхГруппДоступа(Знач НеСоздавать = Ложь, НаименованиеГруппыЭлементов = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаименованиеГруппыЭлементов = НСтр("ru = 'Персональные группы доступа'");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НаименованиеГруппыЭлементов", НаименованиеГруппыЭлементов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДоступа.Ссылка
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|ГДЕ
	|	ГруппыДоступа.Наименование ПОДОБНО &НаименованиеГруппыЭлементов
	|	И ГруппыДоступа.ЭтоГруппа";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ГруппаЭлементов = Выборка.Ссылка;
	ИначеЕсли НеСоздавать Тогда
		ГруппаЭлементов = Неопределено;
	Иначе
		ГруппаЭлементовОбъект = СоздатьГруппу();
		ГруппаЭлементовОбъект.Наименование = НаименованиеГруппыЭлементов;
		ГруппаЭлементовОбъект.Записать();
		ГруппаЭлементов = ГруппаЭлементовОбъект.Ссылка;
	КонецЕсли;
	
	Возврат ГруппаЭлементов;
	
КонецФункции

Функция ИзменилисьВидыИлиЗначенияДоступа(СтарыеЗначения, ТекущийОбъект) Экспорт
	
	Если СтарыеЗначения.Ссылка <> ТекущийОбъект.Ссылка Тогда
		Возврат Истина;
	КонецЕсли;
	
	ВидыДоступа     = СтарыеЗначения.ВидыДоступа.Выгрузить();
	ЗначенияДоступа = СтарыеЗначения.ЗначенияДоступа.Выгрузить();
	
	Если ВидыДоступа.Количество()     <> ТекущийОбъект.ВидыДоступа.Количество()
	 Или ЗначенияДоступа.Количество() <> ТекущийОбъект.ЗначенияДоступа.Количество() Тогда
		
		Возврат Истина;
	КонецЕсли;
	
	Отбор = Новый Структура("ВидДоступа, ВсеРазрешены");
	Для Каждого Строка Из ТекущийОбъект.ВидыДоступа Цикл
		ЗаполнитьЗначенияСвойств(Отбор, Строка);
		Если ВидыДоступа.НайтиСтроки(Отбор).Количество() = 0 Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Отбор = Новый Структура("ВидДоступа, ЗначениеДоступа, ВключаяНижестоящие");
	Для Каждого Строка Из ТекущийОбъект.ЗначенияДоступа Цикл
		ЗаполнитьЗначенияСвойств(Отбор, Строка);
		Если ЗначенияДоступа.НайтиСтроки(Отбор).Количество() = 0 Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ПользователиДляОбновленияРолей(СтарыеЗначения, ЭлементДанных) Экспорт
	
	Если СтарыеЗначения = Неопределено Тогда
		СтарыеЗначения = Новый Структура("Ссылка, Профиль, ПометкаУдаления")
	КонецЕсли;
	
	// Обновление ролей для добавленных, оставшихся и удаленных пользователей.
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("НовыеУчастники", ?(ТипЗнч(ЭлементДанных) <> Тип("УдалениеОбъекта"),
		ЭлементДанных.Пользователи.ВыгрузитьКолонку("Пользователь"), Новый Массив));
	
	Запрос.УстановитьПараметр("СтарыеУчастники", ?(ЭлементДанных.Ссылка = СтарыеЗначения.Ссылка,
		СтарыеЗначения.Пользователи.Выгрузить().ВыгрузитьКолонку("Пользователь"), Новый Массив));
	
	Если ТипЗнч(ЭлементДанных)         =  Тип("УдалениеОбъекта")
	 Или ЭлементДанных.Профиль         <> СтарыеЗначения.Профиль
	 Или ЭлементДанных.ПометкаУдаления <> СтарыеЗначения.ПометкаУдаления Тогда
		
		// Выбор всех новых и старых участников группы доступа.
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СоставыГруппПользователей.Пользователь КАК Пользователь
		|ИЗ
		|	РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|ГДЕ
		|	(СоставыГруппПользователей.ГруппаПользователей В (&СтарыеУчастники)
		|			ИЛИ СоставыГруппПользователей.ГруппаПользователей В (&НовыеУчастники))";
	Иначе
		// Выбор изменений участников группы доступа.
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Данные.Пользователь КАК Пользователь
		|ИЗ
		|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|		СоставыГруппПользователей.Пользователь КАК Пользователь,
		|		-1 КАК ВидИзмененияСтроки
		|	ИЗ
		|		РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|	ГДЕ
		|		СоставыГруппПользователей.ГруппаПользователей В(&СтарыеУчастники)
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ РАЗЛИЧНЫЕ
		|		СоставыГруппПользователей.Пользователь,
		|		1
		|	ИЗ
		|		РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|	ГДЕ
		|		СоставыГруппПользователей.ГруппаПользователей В(&НовыеУчастники)) КАК Данные
		|
		|СГРУППИРОВАТЬ ПО
		|	Данные.Пользователь
		|
		|ИМЕЮЩИЕ
		|	СУММА(Данные.ВидИзмененияСтроки) <> 0";
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь");
	
КонецФункции

Функция ПользователиДляОбновленияРолейПоПрофилю(Профили) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Профили", Профили);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоставыГруппПользователей.Пользователь КАК Пользователь
	|ИЗ
	|	РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
	|		ПО СоставыГруппПользователей.ГруппаПользователей = ГруппыДоступаПользователи.Пользователь
	|			И (ГруппыДоступаПользователи.Ссылка.Профиль В (&Профили))";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь");
	
КонецФункции

Функция ГруппыДоступаПрофиля(Профили) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Профили", Профили);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДоступа.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|ГДЕ
	|	ГруппыДоступа.Профиль В(&Профили)
	|	И НЕ ГруппыДоступа.ЭтоГруппа";
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

Процедура ЗарегистрироватьСсылки(ВидСсылок, Знач ДобавляемыеСсылки) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	СвойстваВидаСсылок = СвойстваВидаСсылок(ВидСсылок);
	
	УстановитьПривилегированныйРежим(Истина);
	Ссылки = СтандартныеПодсистемыСервер.ПараметрРаботыПрограммы(
		СвойстваВидаСсылок.ИмяПараметраРаботыПрограммы);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ТипЗнч(Ссылки) <> Тип("Массив") Тогда
		Ссылки = Новый Массив;
	КонецЕсли;
	
	ЕстьИзменения = Ложь;
	Если ДобавляемыеСсылки = Null Тогда
		Если Ссылки.Количество() > 0 Тогда
			Ссылки = Новый Массив;
			ЕстьИзменения = Истина;
		КонецЕсли;
		
	ИначеЕсли Ссылки.Количество() = 1
	        И Ссылки[0] = Неопределено Тогда
		
		Возврат; // Ранее было добавлено более 300 ссылок.
	Иначе
		Если ТипЗнч(ДобавляемыеСсылки) <> Тип("Массив") Тогда
			ДобавляемыеСсылки = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДобавляемыеСсылки);
		КонецЕсли;
		Для Каждого ДобавляемаяСсылка Из ДобавляемыеСсылки Цикл
			Если Ссылки.Найти(ДобавляемаяСсылка) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Ссылки.Добавить(ДобавляемаяСсылка);
			ЕстьИзменения = Истина;
		КонецЦикла;
		Если Ссылки.Количество() > 300 Тогда
			Ссылки = Новый Массив;
			Ссылки.Добавить(Неопределено);
			ЕстьИзменения = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЕстьИзменения Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	СтандартныеПодсистемыСервер.УстановитьПараметрРаботыПрограммы(
		СвойстваВидаСсылок.ИмяПараметраРаботыПрограммы, Ссылки);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Функция ЗарегистрированныеСсылки(ВидСсылок) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	СвойстваВидаСсылок = СвойстваВидаСсылок(ВидСсылок);
	
	УстановитьПривилегированныйРежим(Истина);
	Ссылки = СтандартныеПодсистемыСервер.ПараметрРаботыПрограммы(
		СвойстваВидаСсылок.ИмяПараметраРаботыПрограммы);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ТипЗнч(Ссылки) <> Тип("Массив") Тогда
		Ссылки = Новый Массив;
	КонецЕсли;
	
	Если Ссылки.Количество() = 1
	   И Ссылки[0] = Неопределено Тогда
		
		Возврат Ссылки;
	КонецЕсли;
	
	ПроверенныеСсылки = Новый Массив;
	Для Каждого Ссылка Из Ссылки Цикл
		Если СвойстваВидаСсылок.ДопустимыеТипы.СодержитТип(ТипЗнч(Ссылка)) Тогда
			ПроверенныеСсылки.Добавить(Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПроверенныеСсылки;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для поддержки обмена данными в РИБ.

// Только для внутреннего использования.
Процедура ВосстановитьСоставУчастниковГруппыДоступаАдминистраторы(ЭлементДанных) Экспорт
	
	Если ЭлементДанных.ИмяПредопределенныхДанных <> "Администраторы" Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементДанных.Пользователи.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИмяПредопределенныхДанных", "Администраторы");
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ГруппыДоступаПользователи.Пользователь
	|ИЗ
	|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
	|ГДЕ
	|	ГруппыДоступаПользователи.Ссылка.ИмяПредопределенныхДанных = &ИмяПредопределенныхДанных";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЭлементДанных.Пользователи.Найти(Выборка.Пользователь, "Пользователь") = Неопределено Тогда
			ЭлементДанных.Пользователи.Добавить().Пользователь = Выборка.Пользователь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура УдалитьУчастниковГруппыДоступаАдминистраторыБезПользователяИБ() Экспорт
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ГруппыДоступа");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Администраторы);
		Блокировка.Заблокировать();
		
		ГруппаДоступаАдминистраторы = Администраторы.ПолучитьОбъект();
		
		Индекс = ГруппаДоступаАдминистраторы.Пользователи.Количество() - 1;
		Пока Индекс >= 0 Цикл
			ТекущийПользователь = ГруппаДоступаАдминистраторы.Пользователи[Индекс].Пользователь;
			Если ТипЗнч(ТекущийПользователь) = Тип("СправочникСсылка.Пользователи") Тогда
				ИдентификаторПользователяИБ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущийПользователь,
					"ИдентификаторПользователяИБ");
			Иначе
				ИдентификаторПользователяИБ = Неопределено;
			КонецЕсли;
			Если ТипЗнч(ИдентификаторПользователяИБ) = Тип("УникальныйИдентификатор") Тогда
				ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(
					ИдентификаторПользователяИБ);
			Иначе
				ПользовательИБ = Неопределено;
			КонецЕсли;
			Если ПользовательИБ = Неопределено Тогда
				ГруппаДоступаАдминистраторы.Пользователи.Удалить(Индекс);
			КонецЕсли;
			Индекс = Индекс - 1;
		КонецЦикла;
		
		Если ГруппаДоступаАдминистраторы.Модифицированность() Тогда
			ГруппаДоступаАдминистраторы.Записать();
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;	
	
КонецПроцедуры


// Только для внутреннего использования.
Процедура ЗарегистрироватьГруппуДоступаИзмененнуюПриЗагрузке(ЭлементДанных) Экспорт
	
	СтарыеЗначения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭлементДанных.Ссылка,
		"Ссылка, Профиль, ПометкаУдаления, Пользователи, ВидыДоступа, ЗначенияДоступа");
	
	ТребуетсяРегистрация = Ложь;
	ГруппаДоступа = ЭлементДанных.Ссылка;
	
	Если ТипЗнч(ЭлементДанных) = Тип("УдалениеОбъекта") Тогда
		ТребуетсяРегистрация = Истина;
		
	ИначеЕсли СтарыеЗначения.Ссылка <> ЭлементДанных.Ссылка Тогда
		ТребуетсяРегистрация = Истина;
		ГруппаДоступа = ПользователиСлужебный.СсылкаОбъекта(ЭлементДанных);
	
	ИначеЕсли ЭлементДанных.ПометкаУдаления <> СтарыеЗначения.ПометкаУдаления
	      Или ЭлементДанных.Профиль         <> СтарыеЗначения.Профиль Тогда
		
		ТребуетсяРегистрация = Истина;
	Иначе
		НаличиеУчастников = ЭлементДанных.Пользователи.Количество() <> 0;
		СтароеНаличиеУчастников = Не СтарыеЗначения.Пользователи.Пустой();
		
		Если НаличиеУчастников <> СтароеНаличиеУчастников
		 Или ИзменилисьВидыИлиЗначенияДоступа(СтарыеЗначения, ЭлементДанных) Тогда
			
			ТребуетсяРегистрация = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ТребуетсяРегистрация Тогда
		ЗарегистрироватьСсылки("ГруппыДоступа", ГруппаДоступа);
	КонецЕсли;
	
	ПользователиДляОбновления = ПользователиДляОбновленияРолей(СтарыеЗначения, ЭлементДанных);
	
	ЗарегистрироватьСсылки("Пользователи", ПользователиДляОбновления);
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ОбновитьВспомогательныеДанныеГруппДоступаИзмененныхПриЗагрузке() Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		// Изменения групп доступа в АРМ заблокированы и не загружаются в область данных.
		Возврат;
	КонецЕсли;
	
	ИзмененныеГруппыДоступа = ЗарегистрированныеСсылки("ГруппыДоступа");
	Если ИзмененныеГруппыДоступа.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ИзмененныеГруппыДоступа.Количество() = 1
	   И ИзмененныеГруппыДоступа[0] = Неопределено Тогда
		
		РегистрыСведений.ТаблицыГруппДоступа.ОбновитьДанныеРегистра();
		РегистрыСведений.ЗначенияГруппДоступа.ОбновитьДанныеРегистра();
	Иначе
		РегистрыСведений.ТаблицыГруппДоступа.ОбновитьДанныеРегистра(ИзмененныеГруппыДоступа);
		РегистрыСведений.ЗначенияГруппДоступа.ОбновитьДанныеРегистра(ИзмененныеГруппыДоступа);
	КонецЕсли;
	
	Если УправлениеДоступомСлужебный.ОграничиватьДоступНаУровнеЗаписейУниверсально() Тогда
		УправлениеДоступомСлужебный.ЗапланироватьОбновлениеНаборовГруппДоступа(
			"ОбновитьВспомогательныеДанныеГруппДоступаИзмененныхПриЗагрузке");
	КонецЕсли;
	
	ЗарегистрироватьСсылки("ГруппыДоступа", Null);
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ЗарегистрироватьПользователейГруппыПользователейИзмененнойПриЗагрузке(ЭлементДанных) Экспорт
	
	СтарыеЗначения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭлементДанных.Ссылка,
		"Ссылка, ПометкаУдаления, Состав");
	
	ИмяРеквизита = ?(ТипЗнч(ЭлементДанных.Ссылка) = Тип("СправочникСсылка.ГруппыВнешнихПользователей"),
		"ВнешнийПользователь", "Пользователь");
	
	Если СтарыеЗначения.Ссылка = ЭлементДанных.Ссылка Тогда
		СтарыеПользователи = СтарыеЗначения.Состав.Выгрузить().ВыгрузитьКолонку(ИмяРеквизита);
	Иначе
		СтарыеПользователи = Новый Массив;
	КонецЕсли;
	
	Если ТипЗнч(ЭлементДанных) = Тип("УдалениеОбъекта") Тогда
		ПользователиДляОбновления = СтарыеПользователи;
	Иначе
		НовыеПользователи = ЭлементДанных.Состав.ВыгрузитьКолонку(ИмяРеквизита);
		
		Если СтарыеЗначения.Ссылка <> ЭлементДанных.Ссылка Тогда
			ПользователиДляОбновления = НовыеПользователи;
		Иначе
			ПользователиДляОбновления = Новый Массив;
			Все = ЭлементДанных.ПометкаУдаления <> СтарыеЗначения.ПометкаУдаления;
			
			Для Каждого Пользователь Из СтарыеПользователи Цикл
				Если Все Или НовыеПользователи.Найти(Пользователь) = Неопределено Тогда
					ПользователиДляОбновления.Добавить(Пользователь);
				КонецЕсли;
			КонецЦикла;
			
			Для Каждого Пользователь Из НовыеПользователи Цикл
				Если Все Или СтарыеПользователи.Найти(Пользователь) = Неопределено Тогда
					ПользователиДляОбновления.Добавить(Пользователь);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если ПользователиДляОбновления.Количество() > 0 Тогда
		ЗарегистрироватьСсылки("ГруппыПользователей",
			ПользователиСлужебный.СсылкаОбъекта(ЭлементДанных));
	КонецЕсли;
	
	ЗарегистрироватьСсылки("Пользователи", ПользователиДляОбновления);
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ОбновитьВспомогательныеДанныеГруппПользователейИзмененныхПриЗагрузке() Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		// Изменения групп доступа в АРМ заблокированы и не загружаются в область данных.
		Возврат;
	КонецЕсли;
	
	ИзмененныеГруппыПользователей = ЗарегистрированныеСсылки("ГруппыПользователей");
	Если ИзмененныеГруппыПользователей.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если УправлениеДоступомСлужебный.ОграничиватьДоступНаУровнеЗаписейУниверсально() Тогда
		УправлениеДоступомСлужебный.ЗапланироватьОбновлениеДоступаПриКосвенномИзмененииУчастниковГруппыДоступа(
			ИзмененныеГруппыПользователей, Истина);
	КонецЕсли;
	
	ЗарегистрироватьСсылки("ГруппыПользователей", Null);
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ЗарегистрироватьПользователяИзмененногоПриЗагрузке(ЭлементДанных) Экспорт
	
	СтарыеЗначения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭлементДанных.Ссылка,
		"Ссылка, ПометкаУдаления, Недействителен");
	
	ТребуетсяРегистрация = Ложь;
	Пользователь = ЭлементДанных.Ссылка;
	
	Если ТипЗнч(ЭлементДанных) = Тип("УдалениеОбъекта") Тогда
		ТребуетсяРегистрация = Истина;
		
	ИначеЕсли СтарыеЗначения.Ссылка <> ЭлементДанных.Ссылка Тогда
		ТребуетсяРегистрация = Истина;
		Пользователь = ПользователиСлужебный.СсылкаОбъекта(ЭлементДанных);
	
	ИначеЕсли ЭлементДанных.Недействителен <> СтарыеЗначения.Недействителен
		 Или ЭлементДанных.ПометкаУдаления <> СтарыеЗначения.ПометкаУдаления Тогда
			
		ТребуетсяРегистрация = Истина;
	КонецЕсли;
	
	Если Не ТребуетсяРегистрация Тогда
		Возврат;
	КонецЕсли;
	
	ЗарегистрироватьСсылки("ГруппыПользователей",
		?(ТипЗнч(ЭлементДанных.Ссылка) = Тип("СправочникСсылка.Пользователи"),
			Справочники.ГруппыПользователей.ВсеПользователи,
			Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи));
	
	ЗарегистрироватьСсылки("Пользователи", Пользователь);
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ОбновитьРолиПользователейИзмененныхПриЗагрузке() Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		// Изменения профилей в АРМ заблокированы и не загружаются в область данных.
		Возврат;
	КонецЕсли;
	
	ИзмененныеПользователи = ЗарегистрированныеСсылки("Пользователи");
	Если ИзмененныеПользователи.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ИзмененныеПользователи.Количество() = 1
	   И ИзмененныеПользователи[0] = Неопределено Тогда
		
		ИзмененныеПользователи = Неопределено;
	КонецЕсли;
	УправлениеДоступом.ОбновитьРолиПользователей(ИзмененныеПользователи);
	
	Если УправлениеДоступомСлужебный.ОграничиватьДоступНаУровнеЗаписейУниверсально() Тогда
		УправлениеДоступомСлужебный.ЗапланироватьОбновлениеДоступаПриКосвенномИзмененииУчастниковГруппыДоступа(
			ИзмененныеПользователи, Истина);
	КонецЕсли;
	
	ЗарегистрироватьСсылки("Пользователи", Null);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы.

Процедура ЗаполнитьПрофильГруппыДоступаАдминистраторы() Экспорт
	
	Объект = Администраторы.ПолучитьОбъект();
	Если Объект.Профиль <> Справочники.ПрофилиГруппДоступа.Администратор Тогда
		Объект.Профиль = Справочники.ПрофилиГруппДоступа.Администратор;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДоступа.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры,
		Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.ГруппыДоступа");
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	ШаблонОшибкиОбработкиГруппыДоступа =
		НСтр("ru = 'Не удалось обработать группу доступа ""%1"" по причине:
		           |%2'");
	ШаблонОшибкиОбновленияТаблицГруппДоступа =
		НСтр("ru = 'Не удалось обновить таблицы группы доступа ""%1"" по причине:
		           |%2'");
	ШаблонОшибкиОбновленияЗначенийГруппДоступа =
		НСтр("ru = 'Не удалось обновить значения доступа группы доступа ""%1"" по причине:
		           |%2'");
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ГруппыДоступа");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	
	Пока Выборка.Следующий() Цикл
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
		
		НачатьТранзакцию();
		Попытка
			ШаблонОшибки = ШаблонОшибкиОбработкиГруппыДоступа;
			Блокировка.Заблокировать();
			
			ШаблонОшибки = ШаблонОшибкиОбновленияТаблицГруппДоступа;
			РегистрыСведений.ТаблицыГруппДоступа.ОбновитьДанныеРегистра(Выборка.Ссылка);
			
			ШаблонОшибки = ШаблонОшибкиОбновленияЗначенийГруппДоступа;
			РегистрыСведений.ЗначенияГруппДоступа.ОбновитьДанныеРегистра(Выборка.Ссылка);
			
			ШаблонОшибки = ШаблонОшибкиОбработкиГруппыДоступа;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибки,
				Строка(Выборка.Ссылка),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение, , , ТекстСообщения);
			Продолжить;
		КонецПопытки;
		
		ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
		ОбъектовОбработано = ОбъектовОбработано + 1;
	КонецЦикла;
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.ГруппыДоступа") Тогда
		ОбработкаЗавершена = Ложь;
	КонецЕсли;
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре Справочники.ГруппыДоступа.ОбработатьДанныеДляПереходаНаНовуюВерсию не удалось
			           |обновить вспомогательные данные некоторых групп доступа (пропущены): %1'"), 
			ПроблемныхОбъектов);
		
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация,
			Метаданные.НайтиПоПолномуИмени("Справочник.ГруппыДоступа"),,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедура Справочники.ГруппыДоступа.ОбработатьДанныеДляПереходаНаНовуюВерсию
			           |обработала очередную порцию групп доступа: %1'"),
		ОбъектовОбработано));
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

// Для функции ЗарегистрированныеСсылки и процедуры ЗарегистрироватьСсылки.
Функция СвойстваВидаСсылок(ВидСсылок)
	
	Если ВидСсылок = "Профили" Тогда
		ДопустимыеТипы = Новый ОписаниеТипов("СправочникСсылка.ПрофилиГруппДоступа");
		ИмяПараметраРаботыПрограммы = "СтандартныеПодсистемы.УправлениеДоступом.ПрофилиИзмененныеПриЗагрузке";
		
	ИначеЕсли ВидСсылок = "ГруппыДоступа" Тогда
		ДопустимыеТипы = Новый ОписаниеТипов("СправочникСсылка.ГруппыДоступа");
		ИмяПараметраРаботыПрограммы = "СтандартныеПодсистемы.УправлениеДоступом.ГруппыДоступаИзмененныеПриЗагрузке";
		
	ИначеЕсли ВидСсылок = "ГруппыПользователей" Тогда
		ДопустимыеТипы = Новый ОписаниеТипов("СправочникСсылка.ГруппыПользователей,СправочникСсылка.ГруппыВнешнихПользователей");
		ИмяПараметраРаботыПрограммы = "СтандартныеПодсистемы.УправлениеДоступом.ГруппыПользователейИзмененныеПриЗагрузке";
		
	ИначеЕсли ВидСсылок = "Пользователи" Тогда
		ДопустимыеТипы = Новый ОписаниеТипов("СправочникСсылка.Пользователи,СправочникСсылка.ВнешниеПользователи");
		ИмяПараметраРаботыПрограммы = "СтандартныеПодсистемы.УправлениеДоступом.ПользователиИзмененныеПриЗагрузке";
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимое значение ""%1"" параметра ВидСсылок функции СвойстваВидаСсылок.'"),
			ВидСсылок);
	КонецЕсли;
	
	Возврат Новый Структура("ДопустимыеТипы, ИмяПараметраРаботыПрограммы", ДопустимыеТипы, ИмяПараметраРаботыПрограммы);
	
КонецФункции

#КонецОбласти

#КонецЕсли
