﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
//
// Подсистема "Новости".
// ХранилищаНастроек.БуферыОбменаНовостей.МодульМенеджера.
//
// КлючОбъекта, доступные значения:
// - "Документы.Новости.КатегорииПростые";
// - "Документы.Новости.КатегорииИнтервалыВерсий";
// - "Документы.Новости.ПривязкаКМетаданным";
// - "Документы.Новости.БинарныеДанные";
// - "Документы.Новости.Действия";
// - "Справочники.Продукты.Родители" // Только для НовостногоЦентра;
// - "Справочники.Продукты.КаналыРаспространенияНовостей" // Только для НовостногоЦентра;
// - "Справочники.Пользователи.ПраваДоступаКТематическимПодборкам" // Только для НовостногоЦентра.
//
// Состав ключей описан в ОбработкаНовостейКлиентСервер.ПолучитьСтруктуруПолейБуфераОбмена().
//
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

// Получает список настроек для объекта с заданным ключом объекта.
//
// Параметры:
//  КлючОбъекта       - Произвольный, Строка - Ключ объекта;
//  ИмяПользователяИБ - Строка - Имя выбранного пользователя или пустая строка.
//
// Возвращаемое значение:
//   СписокЗначений - Список настроек для объекта с заданным ключом.
//
Функция ПолучитьСписок(КлючОбъекта, ИмяПользователяИБ = "") Экспорт

	Если ПустаяСтрока(ИмяПользователяИБ) Тогда
		ПараметрыТекущегоПользователя = ОбработкаНовостейВызовСервера.ПараметрыТекущегоПользователя();
		лкИмяПользователяИБ = ПараметрыТекущегоПользователя.ИмяПользователяИБ;
	Иначе
		лкИмяПользователяИБ = ИмяПользователяИБ;
	КонецЕсли;

	Результат = ХранилищеОбщихНастроек.ПолучитьСписок("БуферОбмена/" + КлючОбъекта, лкИмяПользователяИБ);

	// Удалить "БуферОбмена/" из наименований.

	Возврат Результат;

КонецФункции

// Удаляет настройку пользователя по заданным Ключу объекта и Ключу настроек.
//
// Параметры:
//  КлючОбъекта       - Произвольный, Строка - Ключ объекта;
//  КлючНастроек      - Произвольный, Строка - Ключ настроек;
//  ИмяПользователяИБ - Строка - Имя выбранного пользователя или пустая строка.
//
Процедура Удалить(КлючОбъекта, КлючНастроек, ИмяПользователяИБ = "") Экспорт

	Если ПустаяСтрока(ИмяПользователяИБ) Тогда
		ПараметрыТекущегоПользователя = ОбработкаНовостейВызовСервера.ПараметрыТекущегоПользователя();
		лкИмяПользователяИБ = ПараметрыТекущегоПользователя.ИмяПользователяИБ;
	Иначе
		лкИмяПользователяИБ = ИмяПользователяИБ;
	КонецЕсли;

	ХранилищеОбщихНастроек.Удалить("БуферОбмена/" + КлючОбъекта, КлючНастроек, лкИмяПользователяИБ);

КонецПроцедуры

Процедура ОбработкаЗагрузки(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек, ИмяПользователяИБ = "")

	Если ПустаяСтрока(ИмяПользователяИБ) Тогда
		ПараметрыТекущегоПользователя = ОбработкаНовостейВызовСервера.ПараметрыТекущегоПользователя();
		лкИмяПользователяИБ = ПараметрыТекущегоПользователя.ИмяПользователяИБ;
	Иначе
		лкИмяПользователяИБ = ИмяПользователяИБ;
	КонецЕсли;

	Если ВРег(КлючОбъекта) = ВРег("Документы.Новости.КатегорииПростые") 
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.КатегорииИнтервалыВерсий")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.ПривязкаКМетаданным")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.БинарныеДанные")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.Действия")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Справочники.Продукты.Родители")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Справочники.Продукты.КаналыРаспространенияНовостей")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Справочники.Пользователи.ПраваДоступаКТематическимПодборкам") Тогда
		Настройки = ХранилищеОбщихНастроек.Загрузить("БуферОбмена/" + КлючОбъекта, КлючНастроек, ОписаниеНастроек, лкИмяПользователяИБ);
		Настройки = ПровестиВалидациюНастроек(Настройки, КлючОбъекта, КлючНастроек);
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПолученияОписания(КлючОбъекта, КлючНастроек, ОписаниеНастроек, ИмяПользователяИБ = "")

	Если ПустаяСтрока(ИмяПользователяИБ) Тогда
		ПараметрыТекущегоПользователя = ОбработкаНовостейВызовСервера.ПараметрыТекущегоПользователя();
		лкИмяПользователяИБ = ПараметрыТекущегоПользователя.ИмяПользователяИБ;
	Иначе
		лкИмяПользователяИБ = ИмяПользователяИБ;
	КонецЕсли;

	Если ВРег(КлючОбъекта) = ВРег("Документы.Новости.КатегорииПростые") 
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.КатегорииИнтервалыВерсий")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.ПривязкаКМетаданным")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.БинарныеДанные")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.Действия")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Справочники.Продукты.Родители")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Справочники.Продукты.КаналыРаспространенияНовостей")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Справочники.Пользователи.ПраваДоступаКТематическимПодборкам") Тогда
		ОписаниеНастроек = ХранилищеОбщихНастроек.ПолучитьОписание("БуферОбмена/" + КлючОбъекта, КлючНастроек, лкИмяПользователяИБ);
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаСохранения(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек, ИмяПользователяИБ = "")

	Если ПустаяСтрока(ИмяПользователяИБ) Тогда
		ПараметрыТекущегоПользователя = ОбработкаНовостейВызовСервера.ПараметрыТекущегоПользователя();
		лкИмяПользователяИБ = ПараметрыТекущегоПользователя.ИмяПользователяИБ;
	Иначе
		лкИмяПользователяИБ = ИмяПользователяИБ;
	КонецЕсли;

	Если ВРег(КлючОбъекта) = ВРег("Документы.Новости.КатегорииПростые") 
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.КатегорииИнтервалыВерсий")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.ПривязкаКМетаданным")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.БинарныеДанные")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.Действия")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Справочники.Продукты.Родители")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Справочники.Продукты.КаналыРаспространенияНовостей")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Справочники.Пользователи.ПраваДоступаКТематическимПодборкам") Тогда
		Настройки = ПровестиВалидациюНастроек(Настройки, КлючОбъекта, КлючНастроек);
		ХранилищеОбщихНастроек.Сохранить("БуферОбмена/" + КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек, лкИмяПользователяИБ);
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаУстановкиОписания(КлючОбъекта, КлючНастроек, ОписаниеНастроек, ИмяПользователяИБ = "")

	Если ПустаяСтрока(ИмяПользователяИБ) Тогда
		ПараметрыТекущегоПользователя = ОбработкаНовостейВызовСервера.ПараметрыТекущегоПользователя();
		лкИмяПользователяИБ = ПараметрыТекущегоПользователя.ИмяПользователяИБ;
	Иначе
		лкИмяПользователяИБ = ИмяПользователяИБ;
	КонецЕсли;

	Если ВРег(КлючОбъекта) = ВРег("Документы.Новости.КатегорииПростые") 
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.КатегорииИнтервалыВерсий")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.ПривязкаКМетаданным")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.БинарныеДанные")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.Действия")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Справочники.Продукты.Родители")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Справочники.Продукты.КаналыРаспространенияНовостей")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Справочники.Пользователи.ПраваДоступаКТематическимПодборкам") Тогда
		ХранилищеОбщихНастроек.УстановитьОписание("БуферОбмена/" + КлючОбъекта, КлючНастроек, ОписаниеНастроек, лкИмяПользователяИБ);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция приводит настройки к правильному виду - удаляет ненужные поля,
//   заполняет поля по-умолчанию, добавляет отсутствующие поля, заполняет поля правильными значениями.
// 
// Параметры:
//  Настройки    - Произвольный - сохраняемые настройки, как правило СписокЗначений Структур;
//  КлючОбъекта  - Строка;
//  КлючНастроек - Строка.
//
// Возвращаемое значение:
//  СписокЗначений - правильное значение настройки со всеми колонками.
//
Функция ПровестиВалидациюНастроек(Настройки, КлючОбъекта, КлючНастроек = "") Экспорт

	ТипСтрока         = Тип("Строка");
	ТипСтруктура      = Тип("Структура");
	ТипСписокЗначений = Тип("СписокЗначений");

	Если ВРег(КлючОбъекта) = ВРег("Документы.Новости.КатегорииПростые") 
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.КатегорииИнтервалыВерсий")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.ПривязкаКМетаданным")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.БинарныеДанные")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Справочники.Продукты.Родители")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Справочники.Продукты.КаналыРаспространенияНовостей")
			ИЛИ ВРег(КлючОбъекта) = ВРег("Справочники.Пользователи.ПраваДоступаКТематическимПодборкам") Тогда

		Результат = Новый СписокЗначений;
		Если ТипЗнч(Настройки) = ТипСписокЗначений Тогда
			Для каждого ТекущееЗначение Из Настройки Цикл
				Если ТипЗнч(ТекущееЗначение.Значение) = ТипСтруктура Тогда
					НовоеТекущееЗначение = ОбработкаНовостейКлиентСервер.ПолучитьСтруктуруПолейБуфераОбмена(КлючОбъекта);
					ЗаполнитьЗначенияСвойств(НовоеТекущееЗначение, ТекущееЗначение.Значение);
					// При передаче буферов обмена из новостного центра в базу чтения новостей и обратно
					//  могут быть несовпадения с конкретными значениями справочников, поэтому необходимо также сохранять и Код.
						Если ВРег(КлючОбъекта) = ВРег("Документы.Новости.КатегорииПростые")
								ИЛИ ВРег(КлючОбъекта) = ВРег("Документы.Новости.КатегорииИнтервалыВерсий") Тогда
							Если НЕ НовоеТекущееЗначение.КатегорияНовостей.Пустая() Тогда
								НовоеТекущееЗначение.КатегорияНовостейКод = НовоеТекущееЗначение.КатегорияНовостей.Код;
							Иначе // Пустое значение элемента справочника? Взять из кода
								Если НЕ ПустаяСтрока(НовоеТекущееЗначение.КатегорияНовостейКод) Тогда
									НовоеТекущееЗначение.КатегорияНовостей = ПланыВидовХарактеристик.КатегорииНовостей.НайтиПоКоду(НовоеТекущееЗначение.КатегорияНовостейКод);
								КонецЕсли;
							КонецЕсли;
							Если НЕ НовоеТекущееЗначение.КатегорияНовостей.Пустая() Тогда
								// Значение категории новостей - ссылочного типа "ЗначенияКатегорийНовостей"?
								Если НовоеТекущееЗначение.КатегорияНовостей.ТипЗначения.Типы()[0] = Тип("СправочникСсылка.ЗначенияКатегорийНовостей") Тогда
									// Если ЗначенияКатегорийНовостей неправильного типа (не "СправочникСсылка.ЗначенияКатегорийНовостей"
									//  или пустое и введен код, то найти по коду).
									Если (ТипЗнч(НовоеТекущееЗначение.ЗначениеКатегорииНовостей) <> Тип("СправочникСсылка.ЗначенияКатегорийНовостей"))
										ИЛИ ((ТипЗнч(НовоеТекущееЗначение.ЗначениеКатегорииНовостей) = Тип("СправочникСсылка.ЗначенияКатегорийНовостей"))
												И НовоеТекущееЗначение.ЗначениеКатегорииНовостей.Пустая()) Тогда
										Если НЕ ПустаяСтрока(НовоеТекущееЗначение.ЗначениеКатегорииНовостейКод) Тогда
											НовоеТекущееЗначение.ЗначениеКатегорииНовостей =
												Справочники["ЗначенияКатегорийНовостей"].НайтиПоКоду(НовоеТекущееЗначение.ЗначениеКатегорииНовостейКод, Ложь, , НовоеТекущееЗначение.КатегорияНовостей);
										КонецЕсли;
									КонецЕсли;
									// А если введено значение ЗначенияКатегорийНовостей, но не заполнен ЗначенияКатегорийНовостейКод, то заполнить его.
									Если (ТипЗнч(НовоеТекущееЗначение.ЗначениеКатегорииНовостей) = Тип("СправочникСсылка.ЗначенияКатегорийНовостей")) Тогда
										Если ПустаяСтрока(НовоеТекущееЗначение.ЗначениеКатегорииНовостейКод) Тогда
											НовоеТекущееЗначение.ЗначениеКатегорииНовостейКод = НовоеТекущееЗначение.ЗначениеКатегорииНовостей.Код;
										КонецЕсли;
									КонецЕсли;
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
						Если ВРег(КлючОбъекта) = ВРег("Документы.Новости.КатегорииИнтервалыВерсий") Тогда
							Если ТипЗнч(НовоеТекущееЗначение.Продукт) = ТипСтрока Тогда
								НовоеТекущееЗначение.ПродуктКод = НовоеТекущееЗначение.Продукт;
							Иначе // Справочник.Продукты
								Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(НовоеТекущееЗначение.Продукт)) = Истина Тогда
									НовоеТекущееЗначение.ПродуктКод = СокрЛП(НовоеТекущееЗначение.Продукт.Код);
								КонецЕсли;
							КонецЕсли;
							// При загрузке данных в новостной центр необходимо заменить Продукт из значения Строка на Справочник.Продукты.
							ИмяСправочника = "Продукты";
							Если Метаданные.Справочники.Найти(ИмяСправочника) <> Неопределено Тогда
								Если НЕ ПустаяСтрока(НовоеТекущееЗначение.ПродуктКод) Тогда
									НовоеТекущееЗначение.Продукт = Справочники[ИмяСправочника].НайтиПоКоду(НовоеТекущееЗначение.ПродуктКод);
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
					Результат.Добавить(НовоеТекущееЗначение);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;

	ИначеЕсли ВРег(КлючОбъекта) = ВРег("Документы.Новости.Действия") Тогда

		Результат = Новый СписокЗначений;
		Если ТипЗнч(Настройки) = ТипСписокЗначений Тогда
			Для каждого ТекущееЗначение Из Настройки Цикл
				Если ТипЗнч(ТекущееЗначение.Значение) = ТипСтруктура Тогда
					НовоеТекущееЗначение = ОбработкаНовостейКлиентСервер.ПолучитьСтруктуруПолейБуфераОбмена(КлючОбъекта);
					ЗаполнитьЗначенияСвойств(НовоеТекущееЗначение, ТекущееЗначение.Значение);
					СписокПараметровДействий = Новый СписокЗначений;
					Если ТекущееЗначение.Значение.Свойство("ПараметрыДействий")
							И ТипЗнч(ТекущееЗначение.Значение.ПараметрыДействий) = ТипСписокЗначений Тогда
						Для каждого ТекущийПараметрДействия Из ТекущееЗначение.Значение.ПараметрыДействий Цикл
							НовоеТекущееЗначениеПараметраДействий = ОбработкаНовостейКлиентСервер.ПолучитьСтруктуруПолейБуфераОбмена("Документы.Новости.ПараметрыДействий");
							ЗаполнитьЗначенияСвойств(НовоеТекущееЗначениеПараметраДействий, ТекущийПараметрДействия.Значение);
							СписокПараметровДействий.Добавить(НовоеТекущееЗначениеПараметраДействий);
						КонецЦикла;
					КонецЕсли;
					НовоеТекущееЗначение.ПараметрыДействий = СписокПараметровДействий;
					Результат.Добавить(НовоеТекущееЗначение);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;

	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецЕсли
